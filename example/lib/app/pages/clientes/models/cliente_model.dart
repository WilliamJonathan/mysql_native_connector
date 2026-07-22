import 'package:mysql_native_connector/mysql_native_connector.dart';

/// Model de domínio — regras/formatação ficam aqui (não na Page).
///
/// Padrão da lib: `fromRow` (sem JSON/HTTP).
class ClienteModel {
  const ClienteModel({
    required this.codigo,
    required this.nome,
    this.fantasia,
    this.cgc,
    this.endereco,
  });

  final String codigo;
  final String nome;
  final String? fantasia;
  final String? cgc;
  final String? endereco;

  factory ClienteModel.fromRow(MysqlRow row) {
    return ClienteModel(
      codigo: row.string('cli_codigo'),
      nome: row.string('cli_nome'),
      fantasia: row.asString('cli_fantasia'),
      cgc: row.asString('cli_cgc'),
      endereco: row.asString('cli_endereco'),
    );
  }

  /// Útil se algum fluxo ainda trouxer Map (não é o caminho principal).
  factory ClienteModel.fromMap(Map<String, Object?> map) {
    String read(String key) => '${map[key] ?? ''}';
    String? readOpt(String key) {
      final value = map[key];
      if (value == null) return null;
      final text = '$value';
      return text.isEmpty ? null : text;
    }

    return ClienteModel(
      codigo: read('cli_codigo'),
      nome: read('cli_nome'),
      fantasia: readOpt('cli_fantasia'),
      cgc: readOpt('cli_cgc'),
      endereco: readOpt('cli_endereco'),
    );
  }

  Map<String, Object?> toMap() => {
    'cli_codigo': codigo,
    'cli_nome': nome,
    'cli_fantasia': fantasia,
    'cli_cgc': cgc,
    'cli_endereco': endereco,
  };

  String get nomeExibicao {
    final fantasiaTrim = fantasia?.trim();
    if (fantasiaTrim != null && fantasiaTrim.isNotEmpty) {
      return '$nome ($fantasiaTrim)';
    }
    return nome;
  }

  String get cgcFormatado {
    final raw = (cgc ?? '').replaceAll(RegExp(r'\D'), '');
    if (raw.length == 11) {
      return '${raw.substring(0, 3)}.${raw.substring(3, 6)}.${raw.substring(6, 9)}-${raw.substring(9)}';
    }
    if (raw.length == 14) {
      return '${raw.substring(0, 2)}.${raw.substring(2, 5)}.${raw.substring(5, 8)}/${raw.substring(8, 12)}-${raw.substring(12)}';
    }
    return cgc ?? '';
  }

  ClienteModel copyWith({
    String? codigo,
    String? nome,
    String? fantasia,
    String? cgc,
    String? endereco,
  }) {
    return ClienteModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      cgc: cgc ?? this.cgc,
      endereco: endereco ?? this.endereco,
    );
  }
}
