/// Anotações estilo Eloquent / Laravel.
///
/// Use com `extends MysqlModel` + `part '*.mysql.g.dart'` e rode:
/// `dart run build_runner build`
library;

/// `@MysqlTable('clientes', orderBy: 'cli_nome')`
class MysqlTable {
  final String name;
  final String? orderBy;

  const MysqlTable(this.name, {this.orderBy});
}

/// `@MysqlColumn('cli_nome')`
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

/// `@MysqlPrimaryKey('cli_codigo')`
class MysqlPrimaryKey extends MysqlColumn {
  const MysqlPrimaryKey(super.name) : super(primaryKey: true, notNull: true);
}

/// `@MysqlNotNull('cli_nome')`
class MysqlNotNull extends MysqlColumn {
  const MysqlNotNull(super.name) : super(notNull: true);
}
