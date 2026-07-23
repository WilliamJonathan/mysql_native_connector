use thiserror::Error;

/// Erros da engine MySQL — sem panic; atravessam o FRB como falha tipada.
#[derive(Debug, Error)]
pub enum DbError {
    #[error("URL de conexão vazia")]
    EmptyUrl,

    #[error("SQL vazio")]
    EmptySql,

    #[error("Pool não inicializado. Chame connect()/init_db_pool primeiro")]
    PoolNotInitialized,

    #[error("Falha ao conectar no MySQL: {0}")]
    Connect(String),

    #[error("Erro no query: {0}")]
    Query(String),

    #[error("Erro no execute: {0}")]
    Execute(String),

    #[error("Falha ao ler coluna índice {index}: {message}")]
    Column { index: usize, message: String },
}

/// Compatibilidade com glue FRB gerado que ainda faz `?` → `String`.
impl From<DbError> for String {
    fn from(value: DbError) -> Self {
        value.to_string()
    }
}
