import 'package:flutter/material.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/models/app_log_entry.dart';
import 'package:mysql_native_connector_example/services/geral_ini_locator.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';
import 'package:mysql_native_connector_example/widgets/connection_panel.dart';
import 'package:mysql_native_connector_example/widgets/log_panel.dart';
import 'package:mysql_native_connector_example/widgets/results_panel.dart';
import 'package:mysql_native_connector_example/widgets/sql_editor_panel.dart';
import 'package:mysql_native_connector_example/widgets/status_bar.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key, this.launchArgs = const []});

  final List<String> launchArgs;

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _user = TextEditingController();
  final _password = TextEditingController();
  final _database = TextEditingController();
  final _sql = TextEditingController(
    text: '''SELECT
  *
FROM clientes
LIMIT 10;''',
  );

  final _logs = <AppLogEntry>[];

  MysqlSession? _session;
  MysqlQueryResult? _result;
  String? _resultMessage;
  String _iniLabel = 'carregando…';
  String _statusDetail = 'Carregando geral.ini';
  bool _useDemo = false;
  bool _busy = false;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    if (widget.launchArgs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _log('Args VB6/ERP: ${widget.launchArgs.join(' ')}');
      });
    }
  }

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _user.dispose();
    _password.dispose();
    _database.dispose();
    _sql.dispose();
    _session?.close();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _reloadIni();
  }

  Future<void> _reloadIni() async {
    try {
      final loaded = await GeralIniLocator.loadPreferred();
      final config = loaded.ini.toMysqlConfig();
      setState(() {
        _iniLabel = loaded.label;
        _host.text = config.host;
        _port.text = '${config.port}';
        _user.text = config.user;
        _password.text = config.password;
        _database.text = config.database;
        _statusDetail = 'geral.ini carregado';
      });
      _log('geral.ini carregado de ${loaded.label}');
    } catch (e) {
      _log('Falha ao ler geral.ini: $e', isError: true);
      setState(() => _statusDetail = 'Falha ao ler geral.ini');
    }
  }

  MysqlConnectionConfig _readConfig() {
    return MysqlConnectionConfig(
      host: _host.text.trim(),
      port: int.tryParse(_port.text.trim()) ?? 3306,
      user: _user.text.trim(),
      password: _password.text,
      database: _database.text.trim(),
    );
  }

  Future<void> _connect() async {
    final config = _readConfig();
    if (config.host.isEmpty || config.user.isEmpty || config.database.isEmpty) {
      _log('Preencha host, usuário e database.', isError: true);
      return;
    }

    setState(() => _busy = true);
    final session = _useDemo ? MysqlSession.demo() : MysqlSession.native();
    try {
      await session.connect(config);
      setState(() {
        _session = session;
        _connected = true;
        _statusDetail =
            '${config.user}@${config.host}:${config.port}/${config.database}';
      });
      _log(
        _useDemo
            ? 'Conectado em modo demonstração (${config.database})'
            : 'Conectado via engine nativa (${config.database})',
      );
    } catch (e) {
      await session.close();
      _log('Conexão falhou: $e', isError: true);
      setState(() {
        _connected = false;
        _session = null;
        _statusDetail = 'Falha na conexão';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disconnect() async {
    setState(() => _busy = true);
    try {
      await _session?.close();
      _log('Sessão encerrada');
    } catch (e) {
      _log('Erro ao desconectar: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _session = null;
          _connected = false;
          _busy = false;
          _statusDetail = 'Desconectado';
        });
      }
    }
  }

  Future<void> _runQuery() async {
    final session = _session;
    if (session == null || !_connected) {
      _log('Conecte antes de executar query.', isError: true);
      return;
    }

    final sql = _sql.text.trim();
    if (sql.isEmpty) return;

    setState(() => _busy = true);
    try {
      final result = await session.query(sql);
      setState(() {
        _result = result;
        _resultMessage = null;
      });
      _log('Query OK · ${result.rowCount} linha(s)');
    } catch (e) {
      _log('Query falhou: $e', isError: true);
      setState(() {
        _result = null;
        _resultMessage = 'Erro na query. Veja o log.';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runExecute() async {
    final session = _session;
    if (session == null || !_connected) {
      _log('Conecte antes de executar comando.', isError: true);
      return;
    }

    final sql = _sql.text.trim();
    if (sql.isEmpty) return;

    setState(() => _busy = true);
    try {
      final affected = await session.execute(sql);
      setState(() {
        _result = null;
        _resultMessage = 'Comando OK · $affected linha(s) afetada(s).';
      });
      _log('Execute OK · $affected linha(s) afetada(s)');
    } catch (e) {
      _log('Execute falhou: $e', isError: true);
      setState(() {
        _result = null;
        _resultMessage = 'Erro no execute. Veja o log.';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _log(String message, {bool isError = false}) {
    setState(() {
      _logs.add(AppLogEntry(message, isError: isError));
      if (_logs.length > 200) {
        _logs.removeRange(0, _logs.length - 200);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MySQL Native Connector'),
            Text(
              'Console desktop para ERP VB6 → Flutter',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                _useDemo ? 'DEMO' : 'NATIVO',
                style: TextStyle(
                  color: _useDemo ? AppTheme.warning : AppTheme.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 360,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: ConnectionPanel(
                              hostController: _host,
                              portController: _port,
                              userController: _user,
                              passwordController: _password,
                              databaseController: _database,
                              iniLabel: _iniLabel,
                              isConnected: _connected,
                              isBusy: _busy,
                              useDemoSession: _useDemo,
                              onUseDemoChanged: (value) {
                                setState(() => _useDemo = value);
                              },
                              onReloadIni: _reloadIni,
                              onConnect: _connect,
                              onDisconnect: _disconnect,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          flex: 2,
                          child: LogPanel(
                            entries: _logs,
                            onClear: () => setState(_logs.clear),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SqlEditorPanel(
                            controller: _sql,
                            enabled: _connected,
                            isBusy: _busy,
                            onQuery: _runQuery,
                            onExecute: _runExecute,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          flex: 3,
                          child: ResultsPanel(
                            result: _result,
                            lastMessage: _resultMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StatusBar(
            connected: _connected,
            demoMode: _useDemo,
            detail: _statusDetail,
          ),
        ],
      ),
    );
  }
}
