import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/endere_cli_model.dart';

part 'cliente_model.mysql.g.dart';

/// Eloquent-style: anotações + `extends MysqlModel&lt;T&gt;` + codegen.
///
/// Depois de mudar anotações, rode no `example/`:
/// `dart run build_runner build --delete-conflicting-outputs`
@MysqlTable('clientes', orderBy: 'cli_nome')
class ClienteModel extends MysqlModel<ClienteModel> {
  ClienteModel({
    required this.codigo,
    required this.nome,
    this.fantasia,
    this.cgc,
    this.endereco,
    this.enderecoCli,
  });

  @MysqlPrimaryKey('cli_codigo')
  final String codigo;

  @MysqlColumn('cli_nome')
  final String nome;

  @MysqlColumn('cli_fantasia')
  final String? fantasia;

  @MysqlColumn('cli_cgc')
  final String? cgc;

  @MysqlColumn('cli_endereco')
  final String? endereco;

  /// LEFT JOIN em `cliente_enderecos` (1:0..1 nesta fase do ORM).
  @LeftJoin(
    table: 'cliente_enderecos',
    localKey: 'cli_codigo',
    foreignKey: 'end_cli',
  )
  final EnderecoCliModel? enderecoCli;

  static MysqlBox<ClienteModel> get box => _ClienteModelMysql.box;

  factory ClienteModel.fromRow(MysqlRow row) => _ClienteModelMysql.fromRow(row);

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
    EnderecoCliModel? enderecoCli,
  }) {
    return ClienteModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      cgc: cgc ?? this.cgc,
      endereco: endereco ?? this.endereco,
      enderecoCli: enderecoCli ?? this.enderecoCli,
    );
  }
}
