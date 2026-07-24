import 'package:mysql_native_connector/src/orm/mysql.dart';

/// Contrato Active Record tipado (CRTP).
///
/// Em Dart, `static` **não herda** — listagens usam [Mysql.of]:
/// `await Mysql.of&lt;ClienteModel&gt;().index()`.
///
/// Na instância (este objeto):
/// `await cliente.store()` / `update()` / `destroy()`.
abstract class MysqlModel<T extends MysqlModel<T>> {
  const MysqlModel();

  /// INSERT ou UPDATE conforme existência da PK.
  Future<T> store() => Mysql.of<T>().store(this as T);

  /// UPDATE exigindo registro existente.
  Future<T> update() => Mysql.of<T>().update(this as T);

  /// DELETE pela PK desta instância.
  Future<bool> destroy() {
    final id = Mysql.of<T>().idOf(this as T);
    if (id == null) return Future.value(false);
    return Mysql.of<T>().destroy(id);
  }
}
