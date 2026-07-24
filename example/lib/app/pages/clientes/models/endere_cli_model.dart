import 'package:mysql_native_connector/mysql_native_connector.dart';

part 'endere_cli_model.mysql.g.dart';

@MysqlTable('cliente_enderecos', orderBy: 'id')
class EnderecoCliModel extends MysqlModel<EnderecoCliModel> {
  EnderecoCliModel({
    required this.id,
    required this.codigoCliente,
    required this.endereco,
    required this.cidade,
    required this.uf,
    required this.bairro,
  });

  @MysqlPrimaryKey('end_id')
  final int id;

  @MysqlColumn('end_cli')
  final String codigoCliente;

  @MysqlColumn('end_endereco')
  final String endereco;

  @MysqlColumn('end_cidade')
  final String cidade;

  @MysqlColumn('end_uf')
  final String uf;

  @MysqlColumn('end_bairro')
  final String bairro;

  static MysqlBox<EnderecoCliModel> get box => _EnderecoCliModelMysql.box;

  factory EnderecoCliModel.fromRow(MysqlRow row) =>
      _EnderecoCliModelMysql.fromRow(row);

  String get resumo => [
    endereco,
    bairro,
    cidade,
    uf,
  ].where((e) => e.trim().isNotEmpty).join(' · ');
}
