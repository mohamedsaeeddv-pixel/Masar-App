part of 'client_details_cubit.dart';

sealed class ClientDetailsState extends Equatable {
  const ClientDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial
final class ClientDetailsInitial extends ClientDetailsState {
  const ClientDetailsInitial();
}

/// Loading
final class ClientDetailsLoading extends ClientDetailsState {
  const ClientDetailsLoading();
}

/// Success
final class ClientDetailsSuccess extends ClientDetailsState {
  final ClientModel client;

  const ClientDetailsSuccess(this.client);

  @override
  List<Object?> get props => [client];
}

/// Failure
final class ClientDetailsFailure extends ClientDetailsState {
  final Failure failure;

  const ClientDetailsFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
