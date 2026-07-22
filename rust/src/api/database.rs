use std::time::Instant;

use chrono::{NaiveDate, NaiveDateTime, NaiveTime};
use once_cell::sync::Lazy;
use sqlx::mysql::{MySqlPoolOptions, MySqlRow};
use sqlx::{Column, MySqlPool, Row, TypeInfo, ValueRef};
use tokio::sync::Mutex;

use super::models::{CellValue, NativeQueryResult};

static POOL: Lazy<Mutex<Option<MySqlPool>>> = Lazy::new(|| Mutex::new(None));

/// Abre (ou substitui) o pool MySQL. Credenciais vêm do Dart (`geral.ini`), nunca hardcoded.
pub async fn init_db_pool(url: String, max_connections: u32) -> Result<(), String> {
    if url.trim().is_empty() {
        return Err("URL de conexão vazia.".into());
    }
    let max = max_connections.max(1);

    let pool = MySqlPoolOptions::new()
        .max_connections(max)
        .acquire_timeout(std::time::Duration::from_secs(15))
        // ERP legado costuma ter DATE/DATETIME = 0000-00-00.
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
        .map_err(|e| format!("Falha ao conectar no MySQL: {e}"))?;

    let mut guard = POOL.lock().await;
    if let Some(old) = guard.take() {
        old.close().await;
    }
    *guard = Some(pool);
    Ok(())
}

/// SELECT → colunas + linhas tipadas.
pub async fn query_sql(sql: String) -> Result<NativeQueryResult, String> {
    let started = Instant::now();
    let sql = sql.trim();
    if sql.is_empty() {
        return Err("SQL vazio.".into());
    }

    let pool = {
        let guard = POOL.lock().await;
        guard
            .as_ref()
            .cloned()
            .ok_or_else(|| "Pool não inicializado. Chame connect()/init_db_pool primeiro.".to_string())?
    };

    let rows = sqlx::query(sql)
        .fetch_all(&pool)
        .await
        .map_err(|e| format!("Erro no query: {e}"))?;

    let columns = if let Some(first) = rows.first() {
        first
            .columns()
            .iter()
            .map(|c| c.name().to_string())
            .collect::<Vec<_>>()
    } else {
        Vec::new()
    };

    let mut out_rows = Vec::with_capacity(rows.len());
    for row in &rows {
        let mut cells = Vec::with_capacity(columns.len());
        for i in 0..columns.len() {
            cells.push(decode_cell(row, i)?);
        }
        out_rows.push(cells);
    }

    Ok(NativeQueryResult {
        columns,
        rows: out_rows,
        rows_affected: None,
        duration_ms: started.elapsed().as_millis() as u64,
    })
}

/// INSERT / UPDATE / DELETE → quantidade de linhas afetadas.
pub async fn execute_sql(sql: String) -> Result<u64, String> {
    let sql = sql.trim();
    if sql.is_empty() {
        return Err("SQL vazio.".into());
    }

    let pool = {
        let guard = POOL.lock().await;
        guard
            .as_ref()
            .cloned()
            .ok_or_else(|| "Pool não inicializado. Chame connect()/init_db_pool primeiro.".to_string())?
    };

    let result = sqlx::query(sql)
        .execute(&pool)
        .await
        .map_err(|e| format!("Erro no execute: {e}"))?;

    Ok(result.rows_affected())
}

/// Fecha o pool explicitamente (obrigatório no ciclo de vida da sessão).
pub async fn close_db_pool() -> Result<(), String> {
    let mut guard = POOL.lock().await;
    if let Some(pool) = guard.take() {
        pool.close().await;
    }
    Ok(())
}

pub async fn is_db_pool_open() -> bool {
    let guard = POOL.lock().await;
    guard.is_some()
}

fn fallback_text_or_null(row: &MySqlRow, index: usize) -> CellValue {
    if let Ok(v) = row.try_get::<String, _>(index) {
        return CellValue::Text(v);
    }
    if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
        return CellValue::Text(String::from_utf8_lossy(&v).into_owned());
    }
    // Datas inválidas (0000-00-00) no protocolo binário do sqlx → NULL
    CellValue::Null
}

fn decode_cell(row: &MySqlRow, index: usize) -> Result<CellValue, String> {
    let col_name = row.column(index).name().to_string();
    let raw = row
        .try_get_raw(index)
        .map_err(|e| format!("Falha ao ler coluna '{col_name}': {e}"))?;
    if raw.is_null() {
        return Ok(CellValue::Null);
    }

    let type_name = raw.type_info().name().to_lowercase();

    match type_name.as_str() {
        "tinyint" | "bool" | "boolean" => {
            if let Ok(v) = row.try_get::<bool, _>(index) {
                return Ok(CellValue::Bool(v));
            }
            if let Ok(v) = row.try_get::<i64, _>(index) {
                return Ok(CellValue::Int64(v));
            }
        }
        "smallint" | "mediumint" | "int" | "integer" | "bigint" | "year" => {
            if let Ok(v) = row.try_get::<i64, _>(index) {
                return Ok(CellValue::Int64(v));
            }
            // BIGINT UNSIGNED acima de i64::MAX
            if let Ok(v) = row.try_get::<u64, _>(index) {
                return Ok(CellValue::Text(v.to_string()));
            }
        }
        "float" | "double" | "real" => {
            if let Ok(v) = row.try_get::<f64, _>(index) {
                return Ok(CellValue::Float64(v));
            }
        }
        "decimal" | "numeric" | "newdecimal" => {
            if let Ok(v) = row.try_get::<String, _>(index) {
                return Ok(CellValue::Text(v));
            }
            if let Ok(v) = row.try_get::<f64, _>(index) {
                return Ok(CellValue::Float64(v));
            }
        }
        "bit" => {
            if let Ok(v) = row.try_get::<bool, _>(index) {
                return Ok(CellValue::Bool(v));
            }
            if let Ok(v) = row.try_get::<i64, _>(index) {
                return Ok(CellValue::Int64(v));
            }
            if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
                return Ok(CellValue::Bytes(v));
            }
        }
        "date" => {
            if let Ok(v) = row.try_get::<NaiveDate, _>(index) {
                return Ok(CellValue::Text(v.to_string()));
            }
            return Ok(fallback_text_or_null(row, index));
        }
        "time" => {
            if let Ok(v) = row.try_get::<NaiveTime, _>(index) {
                return Ok(CellValue::Text(v.to_string()));
            }
            return Ok(fallback_text_or_null(row, index));
        }
        "datetime" | "timestamp" => {
            if let Ok(v) = row.try_get::<NaiveDateTime, _>(index) {
                return Ok(CellValue::Text(
                    v.format("%Y-%m-%d %H:%M:%S").to_string(),
                ));
            }
            return Ok(fallback_text_or_null(row, index));
        }
        "tinyblob" | "blob" | "mediumblob" | "longblob" | "binary" | "varbinary" => {
            if let Ok(v) = row.try_get::<Vec<u8>, _>(index) {
                return Ok(CellValue::Bytes(v));
            }
        }
        // char/varchar/text/enum/set/json caem no fallback genérico abaixo
        _ => {}
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

    // Último recurso: não derruba o SELECT * inteiro por uma coluna.
    Ok(CellValue::Null)
}
