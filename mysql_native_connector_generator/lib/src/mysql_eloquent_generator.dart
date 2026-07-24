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

class _Join {
  _Join({
    required this.fieldName,
    required this.relatedClassName,
    required this.table,
    required this.localKey,
    required this.foreignKey,
    required this.alias,
    required this.columns,
    required this.nullable,
  });

  final String fieldName;
  final String relatedClassName;
  final String table;
  final String localKey;
  final String foreignKey;
  final String alias;
  final List<_Col> columns;
  final bool nullable;
}

/// Gera motor Eloquent: schema, register, fromRow (com LeftJoin).
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
  static final _leftJoinChecker = TypeChecker.typeNamed(
    LeftJoin,
    inPackage: 'mysql_native_connector',
  );
  static final _tableChecker = TypeChecker.typeNamed(
    MysqlTable,
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
    final joins = <_Join>[];

    for (final field in element.fields) {
      if (field.isStatic || field.isSynthetic) continue;

      final leftJoin = _leftJoinAnnotation(field);
      if (leftJoin != null) {
        joins.add(leftJoin);
        continue;
      }

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

    final fromRowArgs = <String>[
      ...columns.map((c) => '${c.fieldName}: ${_rowReader(c)}'),
      ...joins.map((j) => '${j.fieldName}: ${_joinReader(j)}'),
    ].join(',\n      ');

    final toColEntries = columns
        .map((c) => "'${c.columnName}': m.${c.fieldName},")
        .join('\n      ');

    final joinsLiteral = joins.isEmpty
        ? 'const []'
        : '[\n${joins.map(_joinSpecLiteral).join('\n')}\n  ]';

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
    joins: $joinsLiteral,
  );

  static final repo = MysqlRepository<$className>(
    schema: schema,
    fromRow: fromRow,
    toColumns: toColumns,
    idOf: (m) => m.${primary.fieldName},
  );

  static final box = Mysql.register<$className>(
    repo,
    defaultOrderBy: ${defaultOrder == null ? 'null' : "'$defaultOrder'"},
  );

  static $className fromRow(MysqlRow row) {
    return $className(
      $fromRowArgs
    );
  }

  static Map<String, Object?> toColumns($className m) => {
      $toColEntries
    };
}

extension ${className}MysqlColumns on $className {
  Map<String, Object?> toColumns() => $engine.toColumns(this);
}
''';
  }

  String _joinSpecLiteral(_Join j) {
    final cols = j.columns.map((c) => "'${c.columnName}'").join(', ');
    return '''    MysqlJoinSpec(
      table: '${j.table}',
      localKey: '${j.localKey}',
      foreignKey: '${j.foreignKey}',
      alias: '${j.alias}',
      columns: [$cols],
    ),''';
  }

  String _joinReader(_Join j) {
    final detectCol = j.columns.isEmpty
        ? 'null'
        : "row['${j.alias}__${j.columns.first.columnName}']";
    final args = j.columns.map((c) {
      final aliased = _Col(
        fieldName: c.fieldName,
        columnName: '${j.alias}__${c.columnName}',
        dartType: c.dartType,
        nullable: true,
        primaryKey: c.primaryKey,
      );
      return '${c.fieldName}: ${_rowReader(aliased)}';
    }).join(',\n        ');

    return '''($detectCol == null)
          ? null
          : ${j.relatedClassName}(
        $args
      )''';
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

  _Join? _leftJoinAnnotation(FieldElement field) {
    for (final meta in field.metadata.annotations) {
      final value = meta.computeConstantValue();
      if (value == null) continue;
      final type = value.type;
      if (type == null || !_leftJoinChecker.isExactlyType(type)) continue;

      final table = value.getField('table')?.toStringValue();
      final localKey = value.getField('localKey')?.toStringValue();
      final foreignKey = value.getField('foreignKey')?.toStringValue();
      final alias =
          value.getField('alias')?.toStringValue() ?? field.name!;

      if (table == null || localKey == null || foreignKey == null) {
        throw InvalidGenerationSourceError(
          '@LeftJoin incompleto em ${field.name}.',
          element: field,
        );
      }

      final relatedType = field.type;
      final relatedElement = relatedType.element;
      if (relatedElement is! ClassElement) {
        throw InvalidGenerationSourceError(
          '@LeftJoin em ${field.name} precisa de um tipo class (model).',
          element: field,
        );
      }

      // Aceita EnderecoModel? → element ainda é a class.
      final relatedColumns = _columnsOf(relatedElement);
      if (relatedColumns.isEmpty) {
        throw InvalidGenerationSourceError(
          '${relatedElement.name} (join de ${field.name}) precisa de '
          '@MysqlColumn/@MysqlPrimaryKey.',
          element: field,
        );
      }

      // Valida que o relacionado tem @MysqlTable (aviso via tabela explícita).
      _ensureMysqlTable(relatedElement, field);

      return _Join(
        fieldName: field.name!,
        relatedClassName: relatedElement.name!,
        table: table,
        localKey: localKey,
        foreignKey: foreignKey,
        alias: alias,
        columns: relatedColumns,
        nullable: relatedType.nullabilitySuffix == NullabilitySuffix.question,
      );
    }
    return null;
  }

  void _ensureMysqlTable(ClassElement related, FieldElement field) {
    final hasTable = related.metadata.annotations.any((meta) {
      final value = meta.computeConstantValue();
      final type = value?.type;
      return type != null && _tableChecker.isExactlyType(type);
    });
    if (!hasTable) {
      throw InvalidGenerationSourceError(
        '${related.name} usado em @LeftJoin (${field.name}) precisa de @MysqlTable.',
        element: field,
      );
    }
  }

  List<_Col> _columnsOf(ClassElement element) {
    final columns = <_Col>[];
    for (final field in element.fields) {
      if (field.isStatic || field.isSynthetic) continue;
      if (_hasLeftJoinMeta(field)) continue;
      final ann = _columnAnnotation(field);
      if (ann == null) continue;
      columns.add(
        _Col(
          fieldName: field.name!,
          columnName: ann.name,
          dartType: _typeName(field.type),
          nullable: field.type.nullabilitySuffix == NullabilitySuffix.question,
          primaryKey: ann.primaryKey,
        ),
      );
    }
    return columns;
  }

  bool _hasLeftJoinMeta(FieldElement field) {
    for (final meta in field.metadata.annotations) {
      final value = meta.computeConstantValue();
      final type = value?.type;
      if (type != null && _leftJoinChecker.isExactlyType(type)) {
        return true;
      }
    }
    return false;
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
