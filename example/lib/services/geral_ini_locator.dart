import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:path/path.dart' as p;

/// Resolve `geral.ini` como em ERP desktop: pasta do executável, depois CWD, depois asset.
class GeralIniLocator {
  static const assetPath = 'assets/geral.ini.example';

  static Future<({GeralIni ini, String label})> loadPreferred() async {
    final candidates = <String>[
      p.join(Directory.current.path, 'geral.ini'),
      if (Platform.isWindows) p.join(p.dirname(Platform.resolvedExecutable), 'geral.ini'),
    ];

    for (final path in candidates) {
      final file = File(path);
      if (await file.exists()) {
        final ini = await GeralIni.loadFile(path);
        return (ini: ini, label: path);
      }
    }

    final asset = await rootBundle.loadString(assetPath);
    final ini = GeralIni.parse(asset, sourcePath: assetPath);
    return (ini: ini, label: '$assetPath (asset embutido)');
  }
}
