// TODO: Apenas o modelo sabe suas próprias regras de negócio,
// TODO: então é importante colocar as regras de negócio aqui,
// TODO: como validações, formatações, etc.
class ExemploModel {
  final String titulo;
  final String descricao;

  ExemploModel({
    required this.titulo,
    required this.descricao,
  });

  factory ExemploModel.fromJson(Map<String, dynamic> json) {
    return ExemploModel(
      titulo: json['titulo'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
    };
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
