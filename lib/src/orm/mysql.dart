import 'package:mysql_native_connector/src/mysql_session.dart';

/// Ponto de ligação global sessão ↔ ORM (Fase 1).
///
/// Chame [Mysql.bind] após `connect` (ex.: no `AppDatabase.open`).
class Mysql {
  Mysql._();

  static MysqlSession? _session;

  static void bind(MysqlSession session) {
    _session = session;
  }

  static void unbind() {
    _session = null;
  }

  static bool get isBound => _session?.isConnected ?? false;

  static MysqlSession get session {
    final current = _session;
    if (current == null || !current.isConnected) {
      throw StateError(
        'Mysql ORM sem sessão. Chame Mysql.bind(session) após connect().',
      );
    }
    return current;
  }
}
