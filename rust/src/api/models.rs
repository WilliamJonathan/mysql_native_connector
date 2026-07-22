/// Valor de célula tipado (NULL → variante Null → null no Dart).
#[derive(Debug, Clone)]
pub enum CellValue {
    Null,
    Bool(bool),
    Int64(i64),
    Float64(f64),
    Text(String),
    Bytes(Vec<u8>),
}

/// Resultado tabular devolvido ao Dart via flutter_rust_bridge.
#[derive(Debug, Clone)]
pub struct NativeQueryResult {
    pub columns: Vec<String>,
    pub rows: Vec<Vec<CellValue>>,
    pub rows_affected: Option<u64>,
    pub duration_ms: u64,
}
