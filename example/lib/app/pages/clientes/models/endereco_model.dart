import 'package:mysql_native_connector/mysql_native_connector.dart';

part 'endereco_model.mysql.g.dart';

/// Model de exemplo para `@LeftJoin` (só use se a tabela existir no ERP).
///
/// Em [ClienteModel]:
/// ```dart
/// @LeftJoin(
///   table: 'enderecos',
///   localKey: 'cli_codigo',
///   foreignKey: 'end_cliente',
/// )
/// final EnderecoModel? enderecoRel;
/// ```
@MysqlTable('enderecos')
class EnderecoModel extends MysqlModel<EnderecoModel> {
  EnderecoModel({
    required this.id,
    this.clienteCodigo,
    this.logradouro,
    this.cidade,
  });

  @MysqlPrimaryKey('end_codigo')
  final String id;

  @MysqlColumn('end_cliente')
  final String? clienteCodigo;

  @MysqlColumn('end_logradouro')
  final String? logradouro;

  @MysqlColumn('end_cidade')
  final String? cidade;

  static MysqlBox<EnderecoModel> get box => _EnderecoModelMysql.box;

  factory EnderecoModel.fromRow(MysqlRow row) =>
      _EnderecoModelMysql.fromRow(row);
}
