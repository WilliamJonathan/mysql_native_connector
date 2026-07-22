sealed class GenericStates {}

class EmptyGenericState implements GenericStates {}

class LoadingGenericState implements GenericStates {}

class ErrorGenericState implements GenericStates {
  final String message;

  ErrorGenericState({required this.message});
}

class SuccessGenericState<T> implements GenericStates {
  final T data;

  SuccessGenericState({required this.data});
}
