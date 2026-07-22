import 'package:mysql_native_connector_example/app/pages/exemplo/interfaces/i_exemplo_services.dart';
import 'package:mysql_native_connector_example/app/pages/exemplo/models/exemplo_model.dart';
import 'package:mysql_native_connector_example/utils/result_state.dart';

class ExemploServices implements IExemploServices {
  static final ExemploServices _instance = ExemploServices._internal();

  factory ExemploServices() => _instance;

  static ExemploServices get instance => _instance;

  ExemploServices._internal();

  @override
  Future<ResultState<bool>> destroy(ExemploModel model) async {
    // TODO: implement destroy
    throw UnimplementedError();
  }

  @override
  Future<ResultState<List<ExemploModel>>> index() async {
    // TODO: implement index
    throw UnimplementedError();
  }

  @override
  Future<ResultState<ExemploModel>> show(ExemploModel model) async {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<ResultState<ExemploModel>> store(ExemploModel model) async {
    // TODO: implement store
    throw UnimplementedError();
  }

  @override
  Future<ResultState<ExemploModel>> update(ExemploModel model) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
