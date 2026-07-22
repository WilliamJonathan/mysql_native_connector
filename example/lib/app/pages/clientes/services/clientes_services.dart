import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/app/core/database/app_database.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/interfaces/i_clientes_services.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/utils/result_state.dart';

/// Service = SQL + mapeamento. A Page/Store não falam com o banco direto.
class ClientesServices implements IClientesServices {
  ClientesServices._();

  static final ClientesServices instance = ClientesServices._();

  factory ClientesServices() => instance;

  AppDatabase get _db => AppDatabase.instance;

  static const _cols = '''
  cli_codigo,
  cli_nome,
  cli_fantasia,
  cli_cgc,
  cli_endereco
''';

  @override
  Future<ResultState<List<ClienteModel>>> index({int limit = 50}) async {
    try {
      final rows = await _db.queryModels(
        '''
SELECT $_cols
FROM clientes
ORDER BY cli_nome
LIMIT $limit
''',
        ClienteModel.fromRow,
      );
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> show(String codigo) async {
    try {
      final rows = await _db.queryModels(
        '''
SELECT $_cols
FROM clientes
WHERE cli_codigo = ${mysqlLiteral(codigo)}
LIMIT 1
''',
        ClienteModel.fromRow,
      );
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows.first);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<List<ClienteModel>>> search(
    String termo, {
    int limit = 50,
  }) async {
    try {
      final like = mysqlLiteral('%${termo.trim()}%');
      final rows = await _db.queryModels(
        '''
SELECT $_cols
FROM clientes
WHERE cli_nome LIKE $like
   OR cli_fantasia LIKE $like
   OR cli_cgc LIKE $like
ORDER BY cli_nome
LIMIT $limit
''',
        ClienteModel.fromRow,
      );
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> store(ClienteModel model) async {
    try {
      await _db.execute('''
INSERT INTO clientes (cli_codigo, cli_nome, cli_fantasia, cli_cgc, cli_endereco)
VALUES (
  ${mysqlLiteral(model.codigo)},
  ${mysqlLiteral(model.nome)},
  ${mysqlLiteral(model.fantasia)},
  ${mysqlLiteral(model.cgc)},
  ${mysqlLiteral(model.endereco)}
)
''');
      return show(model.codigo);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> update(ClienteModel model) async {
    try {
      final n = await _db.execute('''
UPDATE clientes SET
  cli_nome = ${mysqlLiteral(model.nome)},
  cli_fantasia = ${mysqlLiteral(model.fantasia)},
  cli_cgc = ${mysqlLiteral(model.cgc)},
  cli_endereco = ${mysqlLiteral(model.endereco)}
WHERE cli_codigo = ${mysqlLiteral(model.codigo)}
''');
      if (n <= 0) {
        return ErrorResultState(message: 'Cliente ${model.codigo} não encontrado.');
      }
      return show(model.codigo);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<bool>> destroy(String codigo) async {
    try {
      final n = await _db.execute(
        'DELETE FROM clientes WHERE cli_codigo = ${mysqlLiteral(codigo)}',
      );
      if (n <= 0) return EmptyResultState();
      return SuccessResultState(result: true);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }
}
