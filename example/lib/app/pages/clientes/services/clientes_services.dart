import 'package:mysql_native_connector/mysql_native_connector.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/interfaces/i_clientes_services.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/utils/result_state.dart';

/// Service: exceções → [ResultState]. Store só faz `fold`.
class ClientesServices implements IClientesServices {
  ClientesServices._();

  static final ClientesServices instance = ClientesServices._();

  factory ClientesServices() => instance;

  @override
  Future<ResultState<List<ClienteModel>>> index({int limit = 50}) async {
    try {
      final rows = await ClienteModel.index(limit: limit);
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> show(String codigo) async {
    try {
      final row = await ClienteModel.show(codigo);
      if (row == null) return EmptyResultState();
      return SuccessResultState(result: row);
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
      final rows = await ClienteModel.query()
          .where(
            'cli_nome LIKE $like OR cli_fantasia LIKE $like OR cli_cgc LIKE $like',
          )
          .orderBy('cli_nome')
          .limit(limit)
          .get();
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> store(ClienteModel model) async {
    try {
      final saved = await ClienteModel.store(model);
      return SuccessResultState(result: saved);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> update(ClienteModel model) async {
    try {
      final saved = await ClienteModel.update(model);
      return SuccessResultState(result: saved);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<bool>> destroy(String codigo) async {
    try {
      final ok = await ClienteModel.destroy(codigo);
      if (!ok) return EmptyResultState();
      return SuccessResultState(result: true);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }
}
