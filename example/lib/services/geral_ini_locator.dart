import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:path/path.dart' as p;

/// Resolve `geral.ini` como em ERP desktop.
///
/// Ordem:
/// 1. Ao lado do `.exe` (pasta do executável) — padrão VB6/ShellExecute
/// 2. Diretório de trabalho atual
/// 3. `assets/geral.ini` no CWD (dev)
/// 4. Asset embutido `assets/geral.ini.example`
class GeralIniLocator {
  static const assetPath = 'assets/geral.ini.example';

  static Future<({GeralIni ini, String label})> loadPreferred() async {
    final candidates = <String>[
      if (Platform.isWindows)
        p.join(p.dirname(Platform.resolvedExecutable), 'geral.ini'),
      p.join(Directory.current.path, 'geral.ini'),
      p.join(Directory.current.path, 'assets', 'geral.ini'),
      // flutter run às vezes usa CWD na raiz do plugin
      p.join(Directory.current.path, 'example', 'geral.ini'),
    ];

    final tried = <String>[];
    for (final path in candidates) {
      final normalized = p.normalize(path);
      if (tried.contains(normalized)) continue;
      tried.add(normalized);

      final file = File(normalized);
      if (await file.exists()) {
        final ini = await GeralIni.loadFile(normalized);
        return (ini: ini, label: normalized);
      }
    }

    final asset = await rootBundle.loadString(assetPath);
    final ini = GeralIni.parse(asset, sourcePath: assetPath);
    return (
      ini: ini,
      label: '$assetPath (asset embutido; nenhum geral.ini encontrado em: ${tried.join(' | ')})',
    );
  }
}
