import 'package:mysql_native_connector/src/config/geral_ini.dart';
import 'package:mysql_native_connector/src/config/mysql_connection_config.dart';
import 'package:mysql_native_connector/src/mysql_session.dart';
import 'package:mysql_native_connector/src/orm/mysql_box.dart';
import 'package:mysql_native_connector/src/orm/mysql_repository.dart';

/// Facade global estilo Laravel (`DB` / boot do Eloquent).
///
/// Analogia ObjectBox: `store.box&lt;T&gt;()` → [Mysql.of].
///
/// ```dart
/// await Mysql.bootFromIni(r'C:\erp\geral.ini');
/// final rows = await Mysql.of&lt;ClienteModel&gt;().index();
/// await cliente.store();
/// ```
class Mysql {
  Mysql._();

  static MysqlSession? _session;
  static final Map<Type, MysqlBox<dynamic>> _boxes = {};

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

  /// Registra o repositório tipado (chamado pelo `*.mysql.g.dart` ao carregar).
  static MysqlBox<T> register<T>(
    MysqlRepository<T> repo, {
    String? defaultOrderBy,
  }) {
    final box = MysqlBox<T>(repo, defaultOrderBy: defaultOrderBy);
    _boxes[T] = box;
    return box;
  }

  /// Atalho: registra só se ainda não houver box para [T].
  static MysqlBox<T> registerIfAbsent<T>(
    MysqlRepository<T> Function() factory, {
    String? defaultOrderBy,
  }) {
    final existing = _boxes[T];
    if (existing != null) {
      return existing as MysqlBox<T>;
    }
    return register<T>(factory(), defaultOrderBy: defaultOrderBy);
  }

  /// “Box” tipado — equivalente a ObjectBox `box&lt;T&gt;()`.
  static MysqlBox<T> of<T>() {
    final box = _boxes[T];
    if (box == null) {
      throw StateError(
        'Mysql.of<$T>() sem registro. Importe o model (*.mysql.g.dart) '
        'para o codegen chamar Mysql.register<$T>(...).',
      );
    }
    return box as MysqlBox<T>;
  }

  static bool isRegistered<T>() => _boxes.containsKey(T);

  /// Limpa o registry (útil em testes).
  static void clearRegistry() => _boxes.clear();

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
