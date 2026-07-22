import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/app/pages/exemplo/interfaces/i_exemplo_services.dart';
import 'package:mysql_native_connector_example/app/pages/exemplo/services/exemplo_services.dart';
import 'package:mysql_native_connector_example/utils/generic_states.dart';

class ExemploPageStore extends ChangeNotifier {
  final IExemploServices _exemploServices = ExemploServices.instance;

  GenericStates _state = EmptyGenericState();
  GenericStates get state => _state;
  set state(GenericStates value) {
    _state = value;
    notifyListeners();
  }

  Future<void> index() async {
    state = LoadingGenericState();
    final result = await _exemploServices.index();
    result.fold(
      onSuccess: (data) {
        state = SuccessGenericState(data: data);
      },
      onError: (message) {
        state = ErrorGenericState(message: message);
      },
      onEmpty: () {
        state = EmptyGenericState();
      },
    );
  }
}
