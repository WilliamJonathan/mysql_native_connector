/// Descrição de um LEFT JOIN 1:0..1 (colunas já resolvidas pelo codegen).
class MysqlJoinSpec {
  const MysqlJoinSpec({
    required this.table,
    required this.localKey,
    required this.foreignKey,
    required this.alias,
    required this.columns,
  });

  final String table;
  final String localKey;
  final String foreignKey;

  /// Alias da tabela no SQL (ex.: `endereco`).
  final String alias;

  /// Colunas físicas da tabela join (sem alias).
  final List<String> columns;

  String get quotedTable => '`$table`';
  String get quotedAlias => '`$alias`';

  /// `end_rua` → `endereco__end_rua` (nome da coluna no result set).
  String resultName(String column) => '${alias}__$column';
}

/// Metadados de tabela usados pelo repositório.
///
/// Só colunas listadas em [columns] (anotadas) entram no SELECT da raiz.
/// Joins em [joins] acrescentam colunas `alias__coluna`.
class MysqlTableSchema {
  const MysqlTableSchema({
    required this.name,
    required this.primaryKey,
    required this.columns,
    this.joins = const [],
    this.tableAlias,
  });

  final String name;
  final String primaryKey;
  final List<String> columns;
  final List<MysqlJoinSpec> joins;

  /// Alias da tabela raiz (default: [name]).
  final String? tableAlias;

  String get alias => tableAlias ?? name;

  String get quotedTable => '`$name`';
  String get quotedAlias => '`$alias`';

  bool get hasJoins => joins.isNotEmpty;

  /// Lista SELECT otimizada (só anotadas + joins).
  String get selectListSql {
    final parts = <String>[];
    for (final c in columns) {
      if (hasJoins) {
        parts.add('$quotedAlias.`$c` AS `$c`');
      } else {
        parts.add('`$c`');
      }
    }
    for (final join in joins) {
      for (final c in join.columns) {
        final asName = join.resultName(c);
        parts.add('${join.quotedAlias}.`$c` AS `$asName`');
      }
    }
    return parts.join(', ');
  }

  String get _fromSql {
    final buffer = StringBuffer('$quotedTable');
    if (hasJoins) {
      buffer.write(' AS $quotedAlias');
    }
    for (final join in joins) {
      buffer.write(
        ' LEFT JOIN ${join.quotedTable} AS ${join.quotedAlias}'
        ' ON $quotedAlias.`${join.localKey}` = ${join.quotedAlias}.`${join.foreignKey}`',
      );
    }
    return buffer.toString();
  }

  String _qualifyWhere(String? where) {
    if (where == null || where.trim().isEmpty) return '';
    return ' WHERE ${where.trim()}';
  }

  String selectSql({String? where, String? orderBy, int? limit}) {
    final buffer = StringBuffer(
      'SELECT $selectListSql FROM $_fromSql',
    );
    buffer.write(_qualifyWhere(where));
    if (orderBy != null && orderBy.trim().isNotEmpty) {
      buffer.write(' ORDER BY ${orderBy.trim()}');
    }
    if (limit != null && limit > 0) {
      buffer.write(' LIMIT $limit');
    }
    return buffer.toString();
  }

  String findSql() {
    final pk = hasJoins ? '$quotedAlias.`$primaryKey`' : '`$primaryKey`';
    return 'SELECT $selectListSql FROM $_fromSql WHERE $pk = ? LIMIT 1';
  }

  /// Fase 1 ainda interpola literais; `?` fica reservado para binds na engine.
  String findSqlWithLiteral(Object? id) {
    final pk = hasJoins ? '$quotedAlias.`$primaryKey`' : '`$primaryKey`';
    return 'SELECT $selectListSql FROM $_fromSql'
        ' WHERE $pk = ${_literal(id)} LIMIT 1';
  }

  /// INSERT/UPDATE/DELETE atuam só na tabela raiz (joins são leitura).
  String insertSql(Map<String, Object?> values) {
    final cols = <String>[];
    final vals = <String>[];
    for (final entry in values.entries) {
      cols.add('`${entry.key}`');
      vals.add(_literal(entry.value));
    }
    return 'INSERT INTO $quotedTable (${cols.join(', ')}) VALUES (${vals.join(', ')})';
  }

  String updateSql(Map<String, Object?> values, Object? id) {
    final sets = <String>[];
    for (final entry in values.entries) {
      if (entry.key == primaryKey) continue;
      sets.add('`${entry.key}` = ${_literal(entry.value)}');
    }
    return 'UPDATE $quotedTable SET ${sets.join(', ')}'
        ' WHERE `$primaryKey` = ${_literal(id)}';
  }

  String deleteSql(Object? id) =>
      'DELETE FROM $quotedTable WHERE `$primaryKey` = ${_literal(id)}';

  static String _literal(Object? value) {
    if (value == null) return 'NULL';
    if (value is num || value is bool) return '$value';
    final text = '$value'.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    return "'$text'";
  }
}
