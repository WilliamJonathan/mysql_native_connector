/// Metadados de tabela usados pelo repositório (fonte de verdade na Fase 1).
///
/// Na Fase 2 este objeto será gerado a partir de `@MysqlTable` / `@MysqlColumn`.
class MysqlTableSchema {
  const MysqlTableSchema({
    required this.name,
    required this.primaryKey,
    required this.columns,
  });

  final String name;
  final String primaryKey;
  final List<String> columns;

  String get quotedTable => '`$name`';

  String get columnListSql => columns.map((c) => '`$c`').join(', ');

  String selectSql({String? where, String? orderBy, int? limit}) {
    final buffer = StringBuffer('SELECT $columnListSql FROM $quotedTable');
    if (where != null && where.trim().isNotEmpty) {
      buffer.write(' WHERE ${where.trim()}');
    }
    if (orderBy != null && orderBy.trim().isNotEmpty) {
      buffer.write(' ORDER BY ${orderBy.trim()}');
    }
    if (limit != null && limit > 0) {
      buffer.write(' LIMIT $limit');
    }
    return buffer.toString();
  }

  String findSql() =>
      'SELECT $columnListSql FROM $quotedTable WHERE `$primaryKey` = ? LIMIT 1';

  /// Fase 1 ainda interpola literais; `?` fica reservado para binds na engine.
  String findSqlWithLiteral(Object? id) =>
      'SELECT $columnListSql FROM $quotedTable WHERE `$primaryKey` = ${_literal(id)} LIMIT 1';

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
    return 'UPDATE $quotedTable SET ${sets.join(', ')} WHERE `$primaryKey` = ${_literal(id)}';
  }

  String deleteSql(Object? id) =>
      'DELETE FROM $quotedTable WHERE `$primaryKey` = ${_literal(id)}';

  static String _literal(Object? value) {
    // Evita import circular com query_result — duplicação mínima local.
    if (value == null) return 'NULL';
    if (value is num || value is bool) return '$value';
    final text = '$value'.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    return "'$text'";
  }
}
