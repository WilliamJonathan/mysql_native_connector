import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/utils/result_state.dart';

abstract class IClientesServices {
  Future<ResultState<List<ClienteModel>>> index({int limit = 50});

  Future<ResultState<ClienteModel>> show(String codigo);

  Future<ResultState<List<ClienteModel>>> search(String termo, {int limit = 50});

  Future<ResultState<ClienteModel>> store(ClienteModel model);

  Future<ResultState<ClienteModel>> update(ClienteModel model);

  Future<ResultState<bool>> destroy(String codigo);
}
