import 'package:flutter/material.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/interfaces/i_clientes_services.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/models/cliente_model.dart';
import 'package:mysql_native_connector_example/app/pages/clientes/services/clientes_services.dart';
import 'package:mysql_native_connector_example/utils/generic_states.dart';

class ClientesPageStore extends ChangeNotifier {
  ClientesPageStore({IClientesServices? services})
    : _services = services ?? ClientesServices.instance;

  final IClientesServices _services;

  GenericStates _state = EmptyGenericState();
  GenericStates get state => _state;

  String _filtro = '';
  String get filtro => _filtro;

  set state(GenericStates value) {
    _state = value;
    notifyListeners();
  }

  Future<void> index() async {
    state = LoadingGenericState();
    final result = _filtro.trim().isEmpty
        ? await _services.index()
        : await _services.search(_filtro);

    result.fold(
      onSuccess: (data) =>
          state = SuccessGenericState<List<ClienteModel>>(data: data),
      onError: (message) => state = ErrorGenericState(message: message),
      onEmpty: () => state = EmptyGenericState(),
    );
  }

  Future<void> search(String termo) async {
    _filtro = termo;
    await index();
  }

  Future<void> refresh() => index();
}
