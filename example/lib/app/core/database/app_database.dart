import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/services/geral_ini_locator.dart';

/// Sessão MySQL compartilhada do app example (singleton).
///
/// Services de domínio usam `AppDatabase.instance.session` — sem HTTP.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  MysqlSession? _session;
  MysqlConnectionConfig? _config;
  String? _sourceLabel;

  MysqlSession get session {
    final current = _session;
    if (current == null || !current.isConnected) {
      throw StateError(
        'Banco não conectado. Chame AppDatabase.instance.open() no main.',
      );
    }
    return current;
  }

  bool get isOpen => _session?.isConnected ?? false;
  MysqlConnectionConfig? get config => _config;
  String? get sourceLabel => _sourceLabel;

  /// Abre pool nativo com credenciais do `geral.ini`.
  Future<void> open({bool useDemo = false}) async {
    if (_session?.isConnected == true) {
      await _session!.close();
    }

    final loaded = await GeralIniLocator.loadPreferred();
    final config = loaded.ini.toMysqlConfig();
    final session = useDemo ? MysqlSession.demo() : MysqlSession.native();
    await session.connect(config);

    _session = session;
    _config = config;
    _sourceLabel = loaded.label;
  }

  Future<void> close() async {
    await _session?.close();
    _session = null;
  }

  /// Atalho: SQL puro → result set.
  Future<MysqlQueryResult> query(String sql) => session.query(sql);

  /// Atalho: SQL puro → linhas afetadas.
  Future<int> execute(String sql) => session.execute(sql);

  /// Atalho estilo ORM: `query` + `fromRow`.
  Future<List<T>> queryModels<T>(
    String sql,
    T Function(MysqlRow row) fromRow,
  ) async {
    final result = await query(sql);
    return result.mapRows(fromRow);
  }
}
