import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:source_gen/source_gen.dart';

class _Col {
  _Col({
    required this.fieldName,
    required this.columnName,
    required this.dartType,
    required this.nullable,
    required this.primaryKey,
  });

  final String fieldName;
  final String columnName;
  final String dartType;
  final bool nullable;
  final bool primaryKey;
}

/// Gera `_ClassMysql` com API Laravel: index/show/store/update/destroy.
class MysqlEloquentGenerator extends GeneratorForAnnotation<MysqlTable> {
  static final _columnChecker = TypeChecker.typeNamed(
    MysqlColumn,
    inPackage: 'mysql_native_connector',
  );
  static final _pkChecker = TypeChecker.typeNamed(
    MysqlPrimaryKey,
    inPackage: 'mysql_native_connector',
  );
  static final _nnChecker = TypeChecker.typeNamed(
    MysqlNotNull,
    inPackage: 'mysql_native_connector',
  );

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@MysqlTable só pode ser usado em classes.',
        element: element,
      );
    }

    final className = element.name!;
    final tableName = annotation.read('name').stringValue;
    final orderBy = annotation.peek('orderBy')?.stringValue;

    final columns = <_Col>[];
    for (final field in element.fields) {
      if (field.isStatic || field.isSynthetic) continue;
      final ann = _columnAnnotation(field);
      if (ann == null) continue;

      final type = field.type;
      columns.add(
        _Col(
          fieldName: field.name!,
          columnName: ann.name,
          dartType: _typeName(type),
          nullable: type.nullabilitySuffix == NullabilitySuffix.question,
          primaryKey: ann.primaryKey,
        ),
      );
    }

    if (columns.isEmpty) {
      throw InvalidGenerationSourceError(
        'Nenhuma coluna @MysqlColumn/@MysqlPrimaryKey em $className.',
        element: element,
      );
    }

    final pk = columns.where((c) => c.primaryKey).toList();
    if (pk.length != 1) {
      throw InvalidGenerationSourceError(
        '$className precisa de exatamente 1 @MysqlPrimaryKey.',
        element: element,
      );
    }
    final primary = pk.first;

    final engine = '_${className}Mysql';
    final defaultOrder = orderBy == null
        ? null
        : (orderBy.contains(' ') ? orderBy : '`$orderBy` ASC');

    final fromRowArgs = columns.map((c) {
      final reader = _rowReader(c);
      return '${c.fieldName}: $reader';
    }).join(',\n      ');

    final toColEntries = columns
        .map((c) => "'${c.columnName}': m.${c.fieldName},")
        .join('\n      ');

    return '''
// ignore_for_file: type=lint, unused_element

/// Motor Eloquent gerado para [$className].
class $engine {
  $engine._();

  static const table = '$tableName';
  static const primaryKey = '${primary.columnName}';
  static const columns = [${columns.map((c) => "'${c.columnName}'").join(', ')}];

  static final schema = MysqlTableSchema(
    name: table,
    primaryKey: primaryKey,
    columns: columns,
  );

  static final repo = MysqlRepository<$className>(
    schema: schema,
    fromRow: fromRow,
    toColumns: toColumns,
    idOf: (m) => m.${primary.fieldName},
  );

  static MysqlQuery<$className> query() => repo.query();

  static Future<List<$className>> index({int limit = 50}) {
    return repo.all(
      limit: limit,
      orderBy: ${defaultOrder == null ? 'null' : "'$defaultOrder'"},
    );
  }

  static Future<$className?> show(Object id) => repo.find(id);

  static Future<$className> store($className model) => repo.save(model);

  static Future<$className> update($className model) async {
    final existing = await show(model.${primary.fieldName});
    if (existing == null) {
      throw StateError(
        '$className \${model.${primary.fieldName}} não encontrado.',
      );
    }
    return repo.save(model);
  }

  static Future<bool> destroy(Object id) => repo.deleteById(id);

  static Future<List<$className>> raw(String sql) => repo.raw(sql);

  static $className fromRow(MysqlRow row) {
    return $className(
      $fromRowArgs
    );
  }

  static Map<String, Object?> toColumns($className m) => {
      $toColEntries
    };
}

extension ${className}MysqlInstance on $className {
  Future<$className> save() => $engine.store(this);
  Future<bool> delete() => $engine.destroy(${primary.fieldName});
  Map<String, Object?> toColumns() => $engine.toColumns(this);
}
''';
  }

  MysqlColumn? _columnAnnotation(FieldElement field) {
    for (final meta in field.metadata.annotations) {
      final value = meta.computeConstantValue();
      if (value == null) continue;
      final type = value.type;
      if (type == null) continue;
      if (_pkChecker.isExactlyType(type) ||
          _nnChecker.isExactlyType(type) ||
          _columnChecker.isAssignableFromType(type)) {
        final name = value.getField('name')?.toStringValue();
        final primaryKey = value.getField('primaryKey')?.toBoolValue() ?? false;
        final notNull = value.getField('notNull')?.toBoolValue() ?? false;
        if (name == null) return null;
        return MysqlColumn(name, primaryKey: primaryKey, notNull: notNull);
      }
    }
    return null;
  }

  String _typeName(DartType type) => type.getDisplayString();

  String _rowReader(_Col col) {
    final c = col.columnName;
    final t = col.dartType.replaceAll('?', '');
    if (t == 'String') {
      return col.nullable ? "row.asString('$c')" : "row.string('$c')";
    }
    if (t == 'int') {
      return col.nullable ? "row.asInt('$c')" : "(row.asInt('$c') ?? 0)";
    }
    if (t == 'double') {
      return col.nullable
          ? "row.asDouble('$c')"
          : "(row.asDouble('$c') ?? 0.0)";
    }
    if (t == 'bool') {
      return col.nullable
          ? "row.asBool('$c')"
          : "(row.asBool('$c') ?? false)";
    }
    return col.nullable ? "row.asString('$c')" : "row.string('$c')";
  }
}
