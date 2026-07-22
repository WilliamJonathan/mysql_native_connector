import 'dart:io';

import 'package:mysql_native_connector/src/config/mysql_connection_config.dart';

/// Parser mínimo de INI no estilo ERP legado (`geral.ini`).
///
/// Formato esperado:
/// ```ini
/// [mysql]
/// host=127.0.0.1
/// port=3306
/// user=root
/// password=
/// database=erp
/// max_connections=5
/// ```
///
/// Aceita aliases comuns: `servidor`/`server`, `porta`, `usuario`/`user`,
/// `senha`/`password`, `banco`/`database`/`db`.
class GeralIni {
  GeralIni._(this.sections, {this.sourcePath});

  final Map<String, Map<String, String>> sections;
  final String? sourcePath;

  static Future<GeralIni> loadFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw GeralIniException('Arquivo não encontrado: $path');
    }
    final content = await file.readAsString();
    return parse(content, sourcePath: path);
  }

  static GeralIni parse(String content, {String? sourcePath}) {
    final sections = <String, Map<String, String>>{};
    var current = 'default';
    sections[current] = {};

    for (final rawLine in content.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith(';') || line.startsWith('#')) {
        continue;
      }

      final sectionMatch = RegExp(r'^\[(.+)\]$').firstMatch(line);
      if (sectionMatch != null) {
        current = sectionMatch.group(1)!.trim().toLowerCase();
        sections.putIfAbsent(current, () => {});
        continue;
      }

      final sep = line.indexOf('=');
      if (sep <= 0) continue;

      final key = line.substring(0, sep).trim().toLowerCase();
      var value = line.substring(sep + 1).trim();
      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }
      sections[current]![key] = value;
    }

    return GeralIni._(sections, sourcePath: sourcePath);
  }

  Map<String, String>? section(String name) => sections[name.toLowerCase()];

  /// Resolve seção MySQL (`mysql`, `database`, `db` ou `conexao`).
  MysqlConnectionConfig toMysqlConfig() {
    final data = section('mysql') ??
        section('database') ??
        section('db') ??
        section('conexao') ??
        section('default');

    if (data == null || data.isEmpty) {
      throw GeralIniException(
        'Seção [mysql] (ou [database]/[db]/[conexao]) não encontrada'
        '${sourcePath != null ? ' em $sourcePath' : ''}.',
      );
    }

    String read(List<String> keys, {String? fallback}) {
      for (final key in keys) {
        final value = data[key];
        if (value != null && value.isNotEmpty) return value;
      }
      if (fallback != null) return fallback;
      throw GeralIniException(
        'Chave obrigatória ausente no geral.ini: ${keys.first}',
      );
    }

    final portRaw = read(['port', 'porta'], fallback: '3306');
    final port = int.tryParse(portRaw);
    if (port == null) {
      throw GeralIniException('Porta inválida no geral.ini: $portRaw');
    }

    final maxRaw = read(['max_connections', 'maxconnections'], fallback: '5');
    final maxConnections = int.tryParse(maxRaw) ?? 5;

    return MysqlConnectionConfig(
      host: read(['host', 'servidor', 'server', 'hostname']),
      port: port,
      user: read(['user', 'usuario', 'username', 'uid']),
      password: read(['password', 'senha', 'pwd', 'pass'], fallback: ''),
      database: read(['database', 'banco', 'db', 'dbname']),
      maxConnections: maxConnections,
    );
  }
}

class GeralIniException implements Exception {
  GeralIniException(this.message);
  final String message;

  @override
  String toString() => 'GeralIniException: $message';
}
