import 'package:mysql_native_connector/src/models/query_result.dart';
import 'package:mysql_native_connector/src/orm/mysql.dart';
import 'package:mysql_native_connector/src/orm/mysql_table_schema.dart';

/// Query builder fluido em cima de [MysqlRepository].
///
/// ```dart
/// await ClienteModel.query().orderBy('cli_nome').limit(50).get();
/// ```
class MysqlQuery<T> {
  MysqlQuery(this._repo);

  final MysqlRepository<T> _repo;
  String? _where;
  String? _orderBy;
  int? _limit;

  MysqlQuery<T> where(String clause) {
    _where = clause;
    return this;
  }

  MysqlQuery<T> orderBy(String column, {bool descending = false}) {
    final col = column.contains('`') || column.contains(' ')
        ? column
        : '`$column`';
    _orderBy = descending ? '$col DESC' : '$col ASC';
    return this;
  }

  MysqlQuery<T> limit(int value) {
    _limit = value;
    return this;
  }

  Future<List<T>> get() => _repo.get(
        where: _where,
        orderBy: _orderBy,
        limit: _limit,
      );

  Future<T?> first() async {
    final rows = await limit(1).get();
    if (rows.isEmpty) return null;
    return rows.first;
  }
}

/// Repositório genérico ActiveRecord (CRUD + SQL).
class MysqlRepository<T> {
  MysqlRepository({
    required this.schema,
    required this.fromRow,
    required this.toColumns,
    required this.idOf,
  });

  final MysqlTableSchema schema;
  final T Function(MysqlRow row) fromRow;
  final Map<String, Object?> Function(T model) toColumns;
  final Object? Function(T model) idOf;

  MysqlQuery<T> query() => MysqlQuery<T>(this);

  Future<List<T>> all({int limit = 50, String? orderBy}) {
    return get(orderBy: orderBy, limit: limit);
  }

  Future<List<T>> get({String? where, String? orderBy, int? limit}) async {
    final sql = schema.selectSql(where: where, orderBy: orderBy, limit: limit);
    final result = await Mysql.session.query(sql);
    return result.mapRows(fromRow);
  }

  Future<T?> find(Object id) async {
    final sql = schema.findSqlWithLiteral(id);
    final result = await Mysql.session.query(sql);
    if (result.isEmpty) return null;
    return fromRow(result.rows.first);
  }

  /// INSERT ou UPDATE conforme existência da PK.
  Future<T> save(T model) async {
    final id = idOf(model);
    final values = toColumns(model);
    if (id == null || '$id'.isEmpty) {
      throw StateError('PK ausente para save() em ${schema.name}');
    }

    final existing = await find(id);
    if (existing == null) {
      await Mysql.session.execute(schema.insertSql(values));
    } else {
      await Mysql.session.execute(schema.updateSql(values, id));
    }

    final reloaded = await find(id);
    if (reloaded == null) {
      throw StateError('Falha ao recarregar ${schema.name} após save (id=$id)');
    }
    return reloaded;
  }

  Future<bool> delete(T model) => deleteById(idOf(model));

  Future<bool> deleteById(Object? id) async {
    if (id == null) return false;
    final n = await Mysql.session.execute(schema.deleteSql(id));
    return n > 0;
  }

  /// SQL puro → models (escape hatch permanente).
  Future<List<T>> raw(String sql) async {
    final result = await Mysql.session.query(sql);
    return result.mapRows(fromRow);
  }

  Future<int> executeRaw(String sql) => Mysql.session.execute(sql);
}
