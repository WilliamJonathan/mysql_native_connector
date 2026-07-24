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

  const MysqlColumn(
    this.name, {
    this.primaryKey = false,
    this.notNull = false,
  });
}

/// `@MysqlPrimaryKey('cli_codigo')`
///
/// Classe própria (não estende [MysqlColumn]) para o analyzer conseguir
/// avaliar a constante no `build_runner`.
class MysqlPrimaryKey {
  final String name;

  const MysqlPrimaryKey(this.name);
}

/// `@MysqlNotNull('cli_nome')` — coluna obrigatória (atalho semântico).
class MysqlNotNull {
  final String name;

  const MysqlNotNull(this.name);
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
class LeftJoin {
  final String table;
  final String localKey;
  final String foreignKey;
  final String? alias;

  const LeftJoin({
    required this.table,
    required this.localKey,
    required this.foreignKey,
    this.alias,
  });
}
