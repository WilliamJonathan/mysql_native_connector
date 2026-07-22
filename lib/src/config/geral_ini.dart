import 'dart:convert';
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
    final content = await readIniText(file);
    return parse(content, sourcePath: path);
  }

  /// Lê bytes com suporte a UTF-8 (BOM), UTF-16 LE/BE e fallback Latin-1 (ANSI).
  static Future<String> readIniText(File file) async {
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      return '';
    }

    // UTF-8 BOM
    if (bytes.length >= 3 &&
        bytes[0] == 0xEF &&
        bytes[1] == 0xBB &&
        bytes[2] == 0xBF) {
      return utf8.decode(bytes.sublist(3));
    }

    // UTF-16 LE BOM
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      return _decodeUtf16(bytes.sublist(2), littleEndian: true);
    }

    // UTF-16 BE BOM
    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      return _decodeUtf16(bytes.sublist(2), littleEndian: false);
    }

    // UTF-16 LE sem BOM (comum em Notepad "Unicode"): muitos NULs
    if (_looksLikeUtf16Le(bytes)) {
      return _decodeUtf16(bytes, littleEndian: true);
    }

    try {
      return utf8.decode(bytes);
    } on FormatException {
      // ERP Windows frequentemente grava ANSI / Windows-1252.
      return latin1.decode(bytes);
    }
  }

  static bool _looksLikeUtf16Le(List<int> bytes) {
    if (bytes.length < 4 || bytes.length.isOdd) return false;
    var nulOnOdd = 0;
    final sample = bytes.length < 40 ? bytes.length : 40;
    for (var i = 1; i < sample; i += 2) {
      if (bytes[i] == 0) nulOnOdd++;
    }
    return nulOnOdd >= (sample ~/ 4);
  }

  static String _decodeUtf16(List<int> bytes, {required bool littleEndian}) {
    final codeUnits = <int>[];
    for (var i = 0; i + 1 < bytes.length; i += 2) {
      final unit = littleEndian
          ? (bytes[i] | (bytes[i + 1] << 8))
          : (bytes[i + 1] | (bytes[i] << 8));
      codeUnits.add(unit);
    }
    return String.fromCharCodes(codeUnits);
  }

  static GeralIni parse(String content, {String? sourcePath}) {
    // Remove BOM residual se ainda vier no texto.
    var text = content;
    if (text.isNotEmpty && text.codeUnitAt(0) == 0xFEFF) {
      text = text.substring(1);
    }

    final sections = <String, Map<String, String>>{};
    var current = 'default';
    sections[current] = {};

    for (final rawLine in text.split(RegExp(r'\r?\n'))) {
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
      sections.putIfAbsent(current, () => {});
      sections[current]![key] = value;
    }

    return GeralIni._(sections, sourcePath: sourcePath);
  }

  Map<String, String>? section(String name) => sections[name.toLowerCase()];

  /// Resolve seção MySQL (`mysql`, `database`, `db`, `banco` ou `conexao`).
  MysqlConnectionConfig toMysqlConfig() {
    final data = section('mysql') ??
        section('database') ??
        section('db') ??
        section('banco') ??
        section('conexao') ??
        section('default');

    if (data == null || data.isEmpty) {
      throw GeralIniException(
        'Seção [mysql] (ou [database]/[db]/[banco]/[conexao]) não encontrada'
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
        'Chave obrigatória ausente no geral.ini'
        '${sourcePath != null ? ' ($sourcePath)' : ''}: ${keys.first}',
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
