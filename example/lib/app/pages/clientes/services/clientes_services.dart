import 'package:mysql_native_connector_example/app/pages/clientes/interfaces/i_clientes_services.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/utils/result_state.dart';

/// Camada de aplicação: traduz ORM/exceções → [ResultState].
///
/// O Store só faz `fold`; UI não vê throw cru.
class ClientesServices implements IClientesServices {
  ClientesServices._();

  static final ClientesServices instance = ClientesServices._();

  factory ClientesServices() => instance;

  @override
  Future<ResultState<List<ClienteModel>>> index({int limit = 50}) async {
    try {
      final rows = await ClienteModel.all(limit: limit);
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> show(String codigo) async {
    try {
      final row = await ClienteModel.find(codigo);
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
      final rows = await ClienteModel.search(termo, limit: limit);
      if (rows.isEmpty) return EmptyResultState();
      return SuccessResultState(result: rows);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> store(ClienteModel model) async {
    try {
      final saved = await model.save();
      return SuccessResultState(result: saved);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> update(ClienteModel model) async {
    try {
      final existing = await ClienteModel.find(model.codigo);
      if (existing == null) {
        return ErrorResultState(
          message: 'Cliente ${model.codigo} não encontrado.',
        );
      }
      final saved = await model.save();
      return SuccessResultState(result: saved);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }

  @override
  Future<ResultState<bool>> destroy(String codigo) async {
    try {
      final ok = await ClienteModel.db.deleteById(codigo);
      if (!ok) return EmptyResultState();
      return SuccessResultState(result: true);
    } catch (e) {
      return ErrorResultState(message: '$e');
    }
  }
}
