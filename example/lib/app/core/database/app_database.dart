import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/endere_cli_model.dart';
import 'package:mysql_native_connector_example/services/geral_ini_locator.dart';

/// Bootstrap do example — delega ao [Mysql.boot] (sessão global do ORM).
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  MysqlConnectionConfig? _config;
  String? _sourceLabel;

  MysqlSession get session => Mysql.session;

  bool get isOpen => Mysql.isBound;
  MysqlConnectionConfig? get config => _config;
  String? get sourceLabel => _sourceLabel;

  Future<void> open({bool useDemo = false}) async {
    final loaded = await GeralIniLocator.loadPreferred();
    final config = loaded.ini.toMysqlConfig();
    await Mysql.boot(config: config, demo: useDemo);
    _ensureModelsRegistered();
    _config = config;
    _sourceLabel = loaded.label;
  }

  /// Garante [Mysql.of] (top-level/static lazy do Dart só roda ao tocar o box).
  void _ensureModelsRegistered() {
    ClienteModel.box;
    EnderecoCliModel.box;
  }

  Future<void> close() async {
    await Mysql.disconnect();
    _config = null;
    _sourceLabel = null;
  }

  Future<MysqlQueryResult> query(String sql) => session.query(sql);

  Future<int> execute(String sql) => session.execute(sql);

  Future<List<T>> queryModels<T>(
    String sql,
    T Function(MysqlRow row) fromRow,
  ) async {
    final result = await query(sql);
    return result.mapRows(fromRow);
  }
}
