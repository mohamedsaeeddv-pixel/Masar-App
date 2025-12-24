abstract class AddClientState {}

class AddClientInitial extends AddClientState {}

class AddClientLoading extends AddClientState {}

class AddClientSuccess extends AddClientState {
  final String message;
  AddClientSuccess(this.message);
}

class AddClientFailure extends AddClientState {
  final String errMessage;
  AddClientFailure(this.errMessage);
}