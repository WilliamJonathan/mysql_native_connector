/// Base tipada opcional (Fase 1).
///
/// Models podem só usar [MysqlRepository] estático; esta classe documenta o
/// contrato que o codegen da Fase 2 vai materializar.
abstract class MysqlModel<T extends MysqlModel<T>> {
  const MysqlModel();

  /// Mapa coluna SQL → valor (para INSERT/UPDATE).
  Map<String, Object?> toColumns();
}
