/// Contrato mínimo do model Eloquent.
///
/// A classe concreta fica limpa (campos + anotações). O `*.mysql.g.dart`
/// gera o “motor” `_\$XxxMysql` com `index/show/store/update/destroy`.
abstract class MysqlModel {
  const MysqlModel();
}
