import 'package:mysql_native_connector/mysql_native_connector.dart';

/// Template do padrão Page → Store → Service → Model.
///
/// No conector nativo, prefira [fromRow] em vez de fromJson/HTTP.
class ExemploModel {
  final String titulo;
  final String descricao;

  ExemploModel({
    required this.titulo,
    required this.descricao,
  });

  factory ExemploModel.fromRow(MysqlRow row) {
    return ExemploModel(
      titulo: row.string('titulo'),
      descricao: row.string('descricao'),
    );
  }

  ExemploModel copyWith({
    String? titulo,
    String? descricao,
  }) {
    return ExemploModel(
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
    );
  }
}
