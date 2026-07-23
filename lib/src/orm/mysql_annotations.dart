/// Anotações do ORM leve.
///
/// **Fase 1:** marcadores de documentação / contrato futuro (sem codegen).
/// O runtime usa [MysqlTableSchema] declarado manualmente no model.
///
/// **Fase 2:** `source_gen` lerá estas anotações e gerará schema + `fromRow` /
/// `toColumns` / facades estáticas (`ClienteModel.all()`, etc.).
library;

/// Marca a classe como entidade MySQL (`@MysqlTable('clientes')`).
class MysqlTable {
  final String name;
  const MysqlTable(this.name);
}

/// Coluna mapeada (`@MysqlColumn('cli_nome')`).
class MysqlColumn {
  final String name;
  final bool primaryKey;
  final bool notNull;

  const MysqlColumn(
    this.name, {
    this.primaryKey = false,
    this.notNull = false,
  });
}

/// Atalho de PK (`@MysqlPrimaryKey('cli_codigo')`).
class MysqlPrimaryKey extends MysqlColumn {
  const MysqlPrimaryKey(super.name) : super(primaryKey: true, notNull: true);
}

/// Atalho NOT NULL (`@MysqlNotNull('cli_nome')`).
class MysqlNotNull extends MysqlColumn {
  const MysqlNotNull(super.name) : super(notNull: true);
}
