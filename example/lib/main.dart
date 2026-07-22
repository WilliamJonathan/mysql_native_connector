import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/screens/workspace_screen.dart';
import 'package:mysql_native_connector_example/theme/app_theme.dart';

void main(List<String> arguments) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MysqlConnectorApp(launchArgs: arguments));
}

class MysqlConnectorApp extends StatelessWidget {
  const MysqlConnectorApp({super.key, this.launchArgs = const []});

  final List<String> launchArgs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySQL Native Connector',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: WorkspaceScreen(launchArgs: launchArgs),
    );
  }
}

/// Mantido para testes/widget antigos que importam `MyApp`.
typedef MyApp = MysqlConnectorApp;
