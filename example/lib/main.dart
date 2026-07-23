import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/app/core/database/app_database.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/clientes_page.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/stores/clientes_page_store.dart';
import 'package:mysql_native_connector_example/screens/workspace_screen.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();

  String? bootError;
  try {
    // Mysql.boot (via AppDatabase) já faz initNative + connect + bind no ORM.
    await AppDatabase.instance.open();
  } catch (e) {
    bootError = '$e';
  }

  runApp(
    MysqlConnectorApp(
      launchArgs: arguments,
      bootError: bootError,
    ),
  );
}

class MysqlConnectorApp extends StatelessWidget {
  const MysqlConnectorApp({
    super.key,
    this.launchArgs = const [],
    this.bootError,
  });

  final List<String> launchArgs;
  final String? bootError;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientesPageStore()),
      ],
      child: MaterialApp(
        title: 'MySQL Native Connector',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: bootError == null
            ? HomeShell(launchArgs: launchArgs)
            : _BootErrorScreen(message: bootError!),
      ),
    );
  }
}

/// Hub: lista OO (Clientes) + console SQL puro.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.launchArgs = const []});

  final List<String> launchArgs;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ClientesPage(),
      WorkspaceScreen(launchArgs: widget.launchArgs),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Clientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal),
            label: 'SQL',
          ),
        ],
      ),
    );
  }
}

class _BootErrorScreen extends StatelessWidget {
  const _BootErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storage_rounded, size: 48, color: AppTheme.warning),
              const SizedBox(height: 16),
              const Text(
                'Não foi possível abrir o MySQL',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ajuste example/geral.ini (ou o ao lado do .exe) e reinicie.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mantido para testes/widget antigos que importam `MyApp`.
typedef MyApp = MysqlConnectorApp;
