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

  /// Mapeia cada linha para um model de domínio (`Cliente.fromRow`, etc.).
  List<T> mapRows<T>(T Function(MysqlRow row) mapper) =>
      rows.map(mapper).toList(growable: false);
}

/// Uma linha com acesso por índice ou nome de coluna.
///
/// Base do “ORM leve”: models usam `factory X.fromRow(MysqlRow row)`.
class MysqlRow {
  const MysqlRow(this.values, {this.columns = const []});

  final List<Object?> values;
  final List<String> columns;

  Object? operator [](Object key) {
    if (key is int) return values[key];
    if (key is String) {
      final index =
          columns.indexWhere((c) => c.toLowerCase() == key.toLowerCase());
      if (index < 0) return null;
      return values[index];
    }
    throw ArgumentError('Chave de coluna inválida: $key');
  }

  T? getAs<T>(String column) {
    final value = this[column];
    return value is T ? value : null;
  }

  /// Texto (int/bool/etc. viram `toString()`). `null` → `null`.
  String? asString(String column) {
    final value = this[column];
    if (value == null) return null;
    if (value is String) return value;
    return '$value';
  }

  /// Texto com fallback (útil em ERP onde coluna vazia é comum).
  String string(String column, {String fallback = ''}) =>
      asString(column) ?? fallback;

  int? asInt(String column) {
    final value = this[column];
    if (value == null) return null;
    if (value is int) return value;
    if (value is BigInt) return value.toInt();
    if (value is double) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    return int.tryParse('$value');
  }

  double? asDouble(String column) {
    final value = this[column];
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is BigInt) return value.toDouble();
    return double.tryParse('$value');
  }

  bool? asBool(String column) {
    final value = this[column];
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    final text = '$value'.trim().toLowerCase();
    if (text == '1' || text == 'true' || text == 's' || text == 'sim') {
      return true;
    }
    if (text == '0' || text == 'false' || text == 'n' || text == 'nao' || text == 'não') {
      return false;
    }
    return null;
  }

  Map<String, Object?> toMap() {
    final map = <String, Object?>{};
    for (var i = 0; i < columns.length && i < values.length; i++) {
      map[columns[i]] = values[i];
    }
    return map;
  }
}

/// Escape mínimo para interpolar literais em SQL (enquanto não há binds).
/// Prefira SQL com valores controlados / whitelist de colunas.
String mysqlLiteral(Object? value) {
  if (value == null) return 'NULL';
  if (value is num || value is bool) return '$value';
  final text = '$value'.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
  return "'$text'";
}
