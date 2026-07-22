import 'package:mysql_native_connector/src/config/mysql_connection_config.dart';
import 'package:mysql_native_connector/src/models/query_result.dart';

/// Sessão MySQL de alto nível (API pública do plugin).
///
/// A engine Rust (sqlx) será ligada nas próximas etapas. Enquanto isso:
/// - [MysqlSession.demo] simula leitura/escrita para validar a UI
/// - [MysqlSession.native] prepara o caminho real (ainda não implementado)
abstract class MysqlSession {
  bool get isConnected;
  MysqlConnectionConfig? get config;

  Future<void> connect(MysqlConnectionConfig config);
  Future<MysqlQueryResult> query(String sql);
  Future<int> execute(String sql);
  Future<void> close();

  /// Sessão demonstrativa para o example app / testes de UI.
  factory MysqlSession.demo() = _DemoMysqlSession;

  /// Sessão nativa (Rust). Lança até a engine ser implementada.
  factory MysqlSession.native() = _NativeMysqlSession;
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
      MysqlRow(
        [1, 'CLI-001', 'Cliente Demo Alpha', true, '2026-01-10 08:00:00'],
        columns: columns,
      ),
      MysqlRow(
        [2, 'CLI-002', 'Cliente Demo Beta', true, '2026-02-15 14:30:00'],
        columns: columns,
      ),
      MysqlRow(
        [3, 'CLI-003', 'Cliente Demo Gama', false, '2026-03-01 09:12:00'],
        columns: columns,
      ),
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

  @override
  bool get isConnected => false;

  @override
  MysqlConnectionConfig? get config => _config;

  @override
  Future<void> connect(MysqlConnectionConfig config) async {
    _config = config;
    throw UnimplementedError(
      'Engine Rust ainda não implementada. Use MysqlSession.demo() no example '
      'ou aguarde init_db_pool via flutter_rust_bridge.',
    );
  }

  @override
  Future<MysqlQueryResult> query(String sql) {
    throw UnimplementedError('query() nativo pendente.');
  }

  @override
  Future<int> execute(String sql) {
    throw UnimplementedError('execute() nativo pendente.');
  }

  @override
  Future<void> close() async {}
}
