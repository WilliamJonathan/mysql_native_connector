import 'package:mysql_native_connector/mysql_native_connector.dart';

/// Model ActiveRecord de `clientes` (Fase 1: schema manual + repository).
///
/// Anotações já antecipam a Fase 2 (codegen). O runtime usa [schema] / [db].
@MysqlTable('clientes')
class ClienteModel extends MysqlModel<ClienteModel> {
  const ClienteModel({
    required this.codigo,
    required this.nome,
    this.fantasia,
    this.cgc,
    this.endereco,
  });

  static const schema = MysqlTableSchema(
    name: 'clientes',
    primaryKey: 'cli_codigo',
    columns: [
      'cli_codigo',
      'cli_nome',
      'cli_fantasia',
      'cli_cgc',
      'cli_endereco',
    ],
  );

  static final db = MysqlRepository<ClienteModel>(
    schema: schema,
    fromRow: ClienteModel.fromRow,
    toColumns: (m) => m.toColumns(),
    idOf: (m) => m.codigo,
  );

  @MysqlPrimaryKey('cli_codigo')
  final String codigo;

  @MysqlNotNull('cli_nome')
  final String nome;

  @MysqlColumn('cli_fantasia')
  final String? fantasia;

  @MysqlColumn('cli_cgc')
  final String? cgc;

  @MysqlColumn('cli_endereco')
  final String? endereco;

  // --- facades estáticas (Fase 2 gerará automaticamente) ---

  static MysqlQuery<ClienteModel> query() => db.query();

  static Future<List<ClienteModel>> all({int limit = 50}) =>
      db.all(limit: limit, orderBy: '`cli_nome` ASC');

  static Future<ClienteModel?> find(Object id) => db.find(id);

  static Future<List<ClienteModel>> raw(String sql) => db.raw(sql);

  static Future<List<ClienteModel>> search(String termo, {int limit = 50}) {
    final like = mysqlLiteral('%${termo.trim()}%');
    return db.get(
      where:
          'cli_nome LIKE $like OR cli_fantasia LIKE $like OR cli_cgc LIKE $like',
      orderBy: '`cli_nome` ASC',
      limit: limit,
    );
  }

  factory ClienteModel.fromRow(MysqlRow row) {
    return ClienteModel(
      codigo: row.string('cli_codigo'),
      nome: row.string('cli_nome'),
      fantasia: row.asString('cli_fantasia'),
      cgc: row.asString('cli_cgc'),
      endereco: row.asString('cli_endereco'),
    );
  }

  @override
  Map<String, Object?> toColumns() => {
    'cli_codigo': codigo,
    'cli_nome': nome,
    'cli_fantasia': fantasia,
    'cli_cgc': cgc,
    'cli_endereco': endereco,
  };

  /// Persistência da instância (INSERT ou UPDATE).
  Future<ClienteModel> save() => db.save(this);

  Future<bool> delete() => db.delete(this);

  String get nomeExibicao {
    final fantasiaTrim = fantasia?.trim();
    if (fantasiaTrim != null && fantasiaTrim.isNotEmpty) {
      return '$nome ($fantasiaTrim)';
    }
    return nome;
  }

  String get cgcFormatado {
    final raw = (cgc ?? '').replaceAll(RegExp(r'\D'), '');
    if (raw.length == 11) {
      return '${raw.substring(0, 3)}.${raw.substring(3, 6)}.${raw.substring(6, 9)}-${raw.substring(9)}';
    }
    if (raw.length == 14) {
      return '${raw.substring(0, 2)}.${raw.substring(2, 5)}.${raw.substring(5, 8)}/${raw.substring(8, 12)}-${raw.substring(12)}';
    }
    return cgc ?? '';
  }

  ClienteModel copyWith({
    String? codigo,
    String? nome,
    String? fantasia,
    String? cgc,
    String? endereco,
  }) {
    return ClienteModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      cgc: cgc ?? this.cgc,
      endereco: endereco ?? this.endereco,
    );
  }
}
