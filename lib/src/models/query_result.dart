/// Resultado tabular de um SELECT (linhas tipadas sem JSON).
class MysqlQueryResult {
  const MysqlQueryResult({
    required this.columns,
    required this.rows,
    this.rowsAffected,
    this.duration,
  });

  final List<String> columns;
  final List<MysqlRow> rows;
  final int? rowsAffected;
  final Duration? duration;

  bool get isEmpty => rows.isEmpty;
  int get rowCount => rows.length;
}

/// Uma linha com acesso por índice ou nome de coluna.
class MysqlRow {
  const MysqlRow(this.values, {this.columns = const []});

  final List<Object?> values;
  final List<String> columns;

  Object? operator [](Object key) {
    if (key is int) return values[key];
    if (key is String) {
      final index = columns.indexWhere((c) => c.toLowerCase() == key.toLowerCase());
      if (index < 0) return null;
      return values[index];
    }
    throw ArgumentError('Chave de coluna inválida: $key');
  }

  T? getAs<T>(String column) {
    final value = this[column];
    return value is T ? value : null;
  }

  Map<String, Object?> toMap() {
    final map = <String, Object?>{};
    for (var i = 0; i < columns.length && i < values.length; i++) {
      map[columns[i]] = values[i];
    }
    return map;
  }
}
