import 'package:mysql_native_connector_example/app/pages/exemplo/models/exemplo_model.dart';
import 'package:mysql_native_connector_example/utils/result_state.dart';

abstract class IExemploServices {
  Future<ResultState<List<ExemploModel>>> index();
  Future<ResultState<ExemploModel>> show(ExemploModel model);
  Future<ResultState<ExemploModel>> store(ExemploModel model);
  Future<ResultState<ExemploModel>> update(ExemploModel model);
  Future<ResultState<bool>> destroy(ExemploModel model);
}
