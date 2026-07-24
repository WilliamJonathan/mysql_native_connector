import 'package:mysql_native_connector/src/orm/mysql_repository.dart';
import 'package:mysql_native_connector/src/orm/mysql_table_schema.dart';

/// Handle tipado estilo ObjectBox `box&lt;T&gt;()` — operações de tabela.
///
/// ```dart
/// await Mysql.of&lt;ClienteModel&gt;().index();
/// await Mysql.of&lt;ClienteModel&gt;().show('10');
/// ```
class MysqlBox<T> {
  MysqlBox(
    this.repo, {
    this.defaultOrderBy,
  });

  final MysqlRepository<T> repo;
  final String? defaultOrderBy;

  MysqlTableSchema get schema => repo.schema;

  Future<List<T>> index({int limit = 50}) {
    return repo.all(limit: limit, orderBy: defaultOrderBy);
  }

  Future<T?> show(Object id) => repo.find(id);

  /// INSERT ou UPDATE (upsert) conforme existência da PK.
  Future<T> store(T model) => repo.save(model);

  /// UPDATE exigindo que o registro já exista.
  Future<T> update(T model) async {
    final id = repo.idOf(model);
    if (id == null || '$id'.isEmpty) {
      throw StateError('PK ausente para update() em ${schema.name}');
    }
    final existing = await show(id);
    if (existing == null) {
      throw StateError('${schema.name} $id não encontrado.');
    }
    return repo.save(model);
  }

  Future<bool> destroy(Object id) => repo.deleteById(id);

  MysqlQuery<T> query() => repo.query();

  Future<List<T>> raw(String sql) => repo.raw(sql);

  Object? idOf(T model) => repo.idOf(model);
}
