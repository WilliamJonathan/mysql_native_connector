import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:mysql_native_connector/src/config/mysql_connection_config.dart';
import 'package:mysql_native_connector/src/models/query_result.dart';
import 'package:mysql_native_connector/src/rust/api/database.dart' as rust_db;
import 'package:mysql_native_connector/src/rust/api/models.dart' as rust_models;
import 'package:mysql_native_connector/src/rust/frb_generated.dart';

/// Sessão MySQL de alto nível (API pública do plugin).
///
/// - [MysqlSession.demo] simula leitura/escrita para validar a UI sem MySQL
/// - [MysqlSession.native] usa a engine Rust (sqlx) via flutter_rust_bridge
abstract class MysqlSession {
  bool get isConnected;
  MysqlConnectionConfig? get config;

  Future<void> connect(MysqlConnectionConfig config);
  Future<MysqlQueryResult> query(String sql);
  Future<int> execute(String sql);
  Future<void> close();

  /// Sessão demonstrativa para o example app / testes de UI.
  factory MysqlSession.demo() = _DemoMysqlSession;

  /// Sessão nativa (Rust + sqlx).
  factory MysqlSession.native() = _NativeMysqlSession;

  /// Inicializa o FFI Rust. Chame uma vez no `main` do app Windows.
  static Future<void> initNative() => _ensureRustInitialized();
}

Future<void>? _rustInitFuture;

Future<void> _ensureRustInitialized() {
  return _rustInitFuture ??= RustLib.init();
}

class _DemoMysqlSession implements MysqlSession {
  MysqlConnectionConfig? _config;
  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  MysqlConnectionConfig? get config => _config;

  @override
  Future<void> connect(MysqlConnectionConfig config) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _config = config;
    _connected = true;
  }

  @override
  Future<MysqlQueryResult> query(String sql) async {
    _ensureConnected();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final normalized = sql.trim().toLowerCase();
    if (!normalized.startsWith('select')) {
      throw StateError('Use execute() para INSERT/UPDATE/DELETE.');
    }

    const columns = ['id', 'codigo', 'nome', 'ativo', 'criado_em'];
    final rows = [
      MysqlRow([
        1,
        'CLI-001',
        'Cliente Demo Alpha',
        true,
        '2026-01-10 08:00:00',
      ], columns: columns),
      MysqlRow([
        2,
        'CLI-002',
        'Cliente Demo Beta',
        true,
        '2026-02-15 14:30:00',
      ], columns: columns),
      MysqlRow([
        3,
        'CLI-003',
        'Cliente Demo Gama',
        false,
        '2026-03-01 09:12:00',
      ], columns: columns),
    ];

    return MysqlQueryResult(
      columns: columns,
      rows: rows,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Future<int> execute(String sql) async {
    _ensureConnected();
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final normalized = sql.trim().toLowerCase();
    if (normalized.startsWith('select')) {
      throw StateError('Use query() para SELECT.');
    }
    return 1;
  }

  @override
  Future<void> close() async {
    _connected = false;
  }

  void _ensureConnected() {
    if (!_connected) {
      throw StateError('Sessão não conectada. Chame connect() primeiro.');
    }
  }
}

class _NativeMysqlSession implements MysqlSession {
  MysqlConnectionConfig? _config;
  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  MysqlConnectionConfig? get config => _config;

  @override
  Future<void> connect(MysqlConnectionConfig config) async {
    await _ensureRustInitialized();
    try {
      await rust_db.initDbPool(
        url: config.connectionUrl,
        maxConnections: config.maxConnections,
      );
    } catch (e) {
      _connected = false;
      throw StateError(_rustError('connect', e));
    }
    _config = config;
    _connected = true;
  }

  @override
  Future<MysqlQueryResult> query(String sql) async {
    _ensureConnected();
    try {
      final native = await rust_db.querySql(sql: sql);
      return _mapQueryResult(native);
    } catch (e) {
      throw StateError(_rustError('query', e));
    }
  }

  @override
  Future<int> execute(String sql) async {
    _ensureConnected();
    try {
      final affected = await rust_db.executeSql(sql: sql);
      return affected.toInt();
    } catch (e) {
      throw StateError(_rustError('execute', e));
    }
  }

  @override
  Future<void> close() async {
    try {
      await rust_db.closeDbPool();
    } catch (e) {
      throw StateError(_rustError('close', e));
    } finally {
      _connected = false;
    }
  }

  void _ensureConnected() {
    if (!_connected) {
      throw StateError('Sessão não conectada. Chame connect() primeiro.');
    }
  }
}

MysqlQueryResult _mapQueryResult(rust_models.NativeQueryResult native) {
  final columns = native.columns;
  final rows = native.rows
      .map(
        (cells) => MysqlRow(
          cells.map(_cellToObject).toList(growable: false),
          columns: columns,
        ),
      )
      .toList(growable: false);

  return MysqlQueryResult(
    columns: columns,
    rows: rows,
    rowsAffected: native.rowsAffected?.toInt(),
    duration: Duration(milliseconds: native.durationMs.toInt()),
  );
}

Object? _cellToObject(rust_models.CellValue cell) {
  return switch (cell) {
    rust_models.CellValue_Null() => null,
    rust_models.CellValue_Bool(:final field0) => field0,
    rust_models.CellValue_Int64(:final field0) => field0.toInt(),
    rust_models.CellValue_Float64(:final field0) => field0,
    rust_models.CellValue_Text(:final field0) => field0,
    rust_models.CellValue_Bytes(:final field0) => field0,
  };
}

String _rustError(String op, Object error) {
  if (error is FrbException) {
    return 'Rust/$op: $error';
  }
  if (error is AnyhowException) {
    return 'Rust/$op: ${error.message}';
  }
  return 'Rust/$op: $error';
}
