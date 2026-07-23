import 'package:mysql_native_connector/src/config/geral_ini.dart';
import 'package:mysql_native_connector/src/config/mysql_connection_config.dart';
import 'package:mysql_native_connector/src/mysql_session.dart';

/// Facade global estilo Laravel (`DB` / boot do Eloquent).
///
/// ```dart
/// await Mysql.bootFromIni(r'C:\erp\geral.ini');
/// final rows = await ClienteModel.index();
/// ```
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
        'Mysql sem sessão. Chame Mysql.boot(...) ou Mysql.bind(session).',
      );
    }
    return current;
  }

  /// Inicializa FFI (se nativo), conecta e registra a sessão no ORM.
  static Future<MysqlSession> boot({
    required MysqlConnectionConfig config,
    bool demo = false,
    bool initNative = true,
  }) async {
    if (!demo && initNative) {
      await MysqlSession.initNative();
    }
    if (_session?.isConnected == true) {
      await _session!.close();
    }
    final session = demo ? MysqlSession.demo() : MysqlSession.native();
    await session.connect(config);
    bind(session);
    return session;
  }

  /// Atalho: lê `geral.ini` e dá boot.
  static Future<MysqlSession> bootFromIni(
    String path, {
    bool demo = false,
    bool initNative = true,
  }) async {
    final config = (await GeralIni.loadFile(path)).toMysqlConfig();
    return boot(config: config, demo: demo, initNative: initNative);
  }

  static Future<void> disconnect() async {
    final current = _session;
    unbind();
    await current?.close();
  }
}
