//! Engine MySQL (sqlx) exposta via flutter_rust_bridge.
//!
//! Notas de fronteira FFI:
//! - Dart→Rust: `String`/`Vec<u8>` já chegam **owned** (cópias do isolate Dart).
//! - Rust→Dart: FRB serializa valores owned; **não** é seguro devolver `&str`/`&[u8]`
//!   amarrados a buffers de `MySqlRow` (lifetime termina antes do encode SSE/DCO).
//! - Otimização realista: reduzir alocações *intermediárias* no decode e nunca
//!   segurar Mutex/RwLock através de `.await` longos.

use std::time::Instant;

use chrono::{NaiveDate, NaiveDateTime, NaiveTime};
use once_cell::sync::Lazy;
use sqlx::mysql::{MySqlPoolOptions, MySqlRow};
use sqlx::{Column, MySqlPool, Row, TypeInfo, ValueRef};
use tokio::sync::RwLock;

use super::error::DbError;
use super::models::{CellValue, NativeQueryResult};

/// Pool global. `MySqlPool` é `Arc` interno — `clone()` só incrementa refcount.
static POOL: Lazy<RwLock<Option<MySqlPool>>> = Lazy::new(|| RwLock::new(None));

/// Snapshot barato do pool sob read-lock curto (sem `.await` de I/O).
async fn pool_snapshot() -> Result<MySqlPool, DbError> {
    let guard = POOL.read().await;
    guard.clone().ok_or(DbError::PoolNotInitialized)
}

/// Abre (ou substitui) o pool MySQL. Credenciais vêm do Dart (`geral.ini`).
pub async fn init_db_pool(url: String, max_connections: u32) -> Result<(), DbError> {
    if url.trim().is_empty() {
        return Err(DbError::EmptyUrl);
    }
    let max = max_connections.max(1);

    let pool = MySqlPoolOptions::new()
        .max_connections(max)
        .acquire_timeout(std::time::Duration::from_secs(15))
        // ERP legado: DATE/DATETIME = 0000-00-00.
        .after_connect(|conn, _meta| {
            Box::pin(async move {
                let _ = sqlx::query(
                    "SET SESSION sql_mode = REPLACE(REPLACE(REPLACE(@@sql_mode,'NO_ZERO_DATE',''),'NO_ZERO_IN_DATE',''),'ONLY_FULL_GROUP_BY','')",
                )
                .execute(&mut *conn)
                .await;
                let _ = sqlx::query(
                    "SET SESSION sql_mode = CONCAT(@@sql_mode, ',ALLOW_INVALID_DATES')",
                )
                .execute(&mut *conn)
                .await;
                Ok(())
            })
        })
        .connect(&url)
        .await
        .map_err(|e| DbError::Connect(e.to_string()))?;

    // Troca atômica: não aguarda close sob write-lock (evita contenção/deadlock).
    let previous = {
        let mut guard = POOL.write().await;
        guard.replace(pool)
    };
    if let Some(old) = previous {
        old.close().await;
    }
    Ok(())
}

/// SELECT → colunas + linhas tipadas.
pub async fn query_sql(sql: String) -> Result<NativeQueryResult, DbError> {
    let started = Instant::now();
    if sql.trim().is_empty() {
        return Err(DbError::EmptySql);
    }

    let pool = pool_snapshot().await?;

    // `sql` owned permanece vivo; trim empresta `&str` sem nova String.
    let rows = sqlx::query(sql.trim())
        .fetch_all(&pool)
        .await
        .map_err(|e| DbError::Query(e.to_string()))?;

    let columns = match rows.first() {
        Some(first) => first
            .columns()
            .iter()
            .map(|c| c.name().to_owned())
            .collect::<Vec<_>>(),
        None => Vec::new(),
    };

    let col_count = columns.len();
    let mut out_rows = Vec::with_capacity(rows.len());
    for row in &rows {
        let mut cells = Vec::with_capacity(col_count);
        for index in 0..col_count {
            cells.push(decode_cell(row, index)?);
        }
        out_rows.push(cells);
    }

    Ok(NativeQueryResult {
        columns,
        rows: out_rows,
        rows_affected: None,
        duration_ms: u64::try_from(started.elapsed().as_millis()).unwrap_or(u64::MAX),
    })
}

/// INSERT / UPDATE / DELETE → linhas afetadas.
pub async fn execute_sql(sql: String) -> Result<u64, DbError> {
    if sql.trim().is_empty() {
        return Err(DbError::EmptySql);
    }

    let pool = pool_snapshot().await?;
    let result = sqlx::query(sql.trim())
        .execute(&pool)
        .await
        .map_err(|e| DbError::Execute(e.to_string()))?;

    Ok(result.rows_affected())
}

/// Fecha o pool explicitamente (ciclo de vida da sessão).
pub async fn close_db_pool() -> Result<(), DbError> {
    let previous = {
        let mut guard = POOL.write().await;
        guard.take()
    };
    if let Some(pool) = previous {
        pool.close().await;
    }
    Ok(())
}

pub async fn is_db_pool_open() -> bool {
    POOL.read().await.is_some()
}

fn fallback_text_or_null(row: &MySqlRow, index: usize) -> CellValue {
    if let Ok(v) = row.try_get::<String, _>(index) {
        return CellValue::Text(v);
    }
    if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
        // lossy → owned; inevitável se encoding inválido.
        return CellValue::Text(String::from_utf8_lossy(&v).into_owned());
    }
    CellValue::Null
}

/// Comparação ASCII case-insensitive sem alocar `to_lowercase()`.
fn type_is(name: &str, candidates: &[&str]) -> bool {
    candidates
        .iter()
        .any(|candidate| name.eq_ignore_ascii_case(candidate))
}

fn decode_cell(row: &MySqlRow, index: usize) -> Result<CellValue, DbError> {
    // `try_get_raw` valida índice — evita panic de indexação direta.
    let raw = row.try_get_raw(index).map_err(|e| DbError::Column {
        index,
        message: e.to_string(),
    })?;
    if raw.is_null() {
        return Ok(CellValue::Null);
    }

    // `type_info()` devolve Cow temporário — binding estende lifetime do name.
    let type_info = raw.type_info();
    let type_name = type_info.name();

    if type_is(type_name, &["tinyint", "bool", "boolean"]) {
        if let Ok(v) = row.try_get::<bool, _>(index) {
            return Ok(CellValue::Bool(v));
        }
        if let Ok(v) = row.try_get::<i64, _>(index) {
            return Ok(CellValue::Int64(v));
        }
    } else if type_is(
        type_name,
        &["smallint", "mediumint", "int", "integer", "bigint", "year"],
    ) {
        if let Ok(v) = row.try_get::<i64, _>(index) {
            return Ok(CellValue::Int64(v));
        }
        if let Ok(v) = row.try_get::<u64, _>(index) {
            // UINT64 > i64::MAX: texto evita perda; alocação pontual.
            return Ok(CellValue::Text(v.to_string()));
        }
    } else if type_is(type_name, &["float", "double", "real"]) {
        if let Ok(v) = row.try_get::<f64, _>(index) {
            return Ok(CellValue::Float64(v));
        }
    } else if type_is(type_name, &["decimal", "numeric", "newdecimal"]) {
        if let Ok(v) = row.try_get::<String, _>(index) {
            return Ok(CellValue::Text(v));
        }
        if let Ok(v) = row.try_get::<f64, _>(index) {
            return Ok(CellValue::Float64(v));
        }
    } else if type_is(type_name, &["bit"]) {
        if let Ok(v) = row.try_get::<bool, _>(index) {
            return Ok(CellValue::Bool(v));
        }
        if let Ok(v) = row.try_get::<i64, _>(index) {
            return Ok(CellValue::Int64(v));
        }
        if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
            return Ok(CellValue::Bytes(v));
        }
    } else if type_is(type_name, &["date"]) {
        if let Ok(v) = row.try_get::<NaiveDate, _>(index) {
            return Ok(CellValue::Text(v.to_string()));
        }
        return Ok(fallback_text_or_null(row, index));
    } else if type_is(type_name, &["time"]) {
        if let Ok(v) = row.try_get::<NaiveTime, _>(index) {
            return Ok(CellValue::Text(v.to_string()));
        }
        return Ok(fallback_text_or_null(row, index));
    } else if type_is(type_name, &["datetime", "timestamp"]) {
        if let Ok(v) = row.try_get::<NaiveDateTime, _>(index) {
            return Ok(CellValue::Text(
                v.format("%Y-%m-%d %H:%M:%S").to_string(),
            ));
        }
        return Ok(fallback_text_or_null(row, index));
    } else if type_is(
        type_name,
        &[
            "tinyblob",
            "blob",
            "mediumblob",
            "longblob",
            "binary",
            "varbinary",
        ],
    ) {
        if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
            return Ok(CellValue::Bytes(v));
        }
    }

    if let Ok(v) = row.try_get::<String, _>(index) {
        return Ok(CellValue::Text(v));
    }
    if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
        return Ok(CellValue::Text(String::from_utf8_lossy(&v).into_owned()));
    }
    if let Ok(v) = row.try_get::<i64, _>(index) {
        return Ok(CellValue::Int64(v));
    }
    if let Ok(v) = row.try_get::<f64, _>(index) {
        return Ok(CellValue::Float64(v));
    }

    // Coluna ilegível ≠ panic do processo Flutter.
    Ok(CellValue::Null)
}
