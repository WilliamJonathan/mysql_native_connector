/// Anotações estilo Eloquent / Laravel.
///
/// Use com `extends MysqlModel&lt;T&gt;` + `part '*.mysql.g.dart'` e rode:
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

  const MysqlColumn(this.name, {this.primaryKey = false, this.notNull = false});
}

/// `@MysqlPrimaryKey('cli_codigo')`
class MysqlPrimaryKey extends MysqlColumn {
  const MysqlPrimaryKey(super.name) : super(primaryKey: true, notNull: true);
}

/// `@MysqlNotNull('cli_nome')`
class MysqlNotNull extends MysqlColumn {
  const MysqlNotNull(super.name) : super(notNull: true);
}

/// Relação 1:0..1 via LEFT JOIN (somente leitura nesta fase).
///
/// ```dart
/// @LeftJoin(
///   table: 'enderecos',
///   localKey: 'cli_codigo',
///   foreignKey: 'end_cliente',
/// )
/// final EnderecoModel? endereco;
/// ```
///
/// Só colunas anotadas do model relacionado entram no SELECT (com alias).
class LeftJoin {
  /// Tabela SQL da relação.
  final String table;

  /// Coluna na tabela **dona** (ex.: `cli_codigo`).
  final String localKey;

  /// Coluna na tabela **join** (ex.: `end_cliente`).
  final String foreignKey;

  /// Alias SQL da tabela join (default: nome do campo Dart).
  final String? alias;

  const LeftJoin({
    required this.table,
    required this.localKey,
    required this.foreignKey,
    this.alias,
  });
}
