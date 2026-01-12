import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/core/models/client_model.dart';
import 'package:masar_app/features/home/data/repos/client_details_repos/client_details_repo.dart';
part 'client_details_state.dart';

class ClientDetailsCubit extends Cubit<ClientDetailsState> {
  final ClientDetailsRepository clientRepository;

  ClientDetailsCubit({
    required this.clientRepository,
  }) : super(const ClientDetailsInitial());

  Future<void> getClientDetails(String clientId) async {
    emit(const ClientDetailsLoading());

    final result = await clientRepository.getCustomerById(
      clientId: clientId,
    );

    result.fold(
      (Failure failure) {
        emit(ClientDetailsFailure(failure));
      },
      (ClientModel client) {
        emit(ClientDetailsSuccess(client));
      },
    );
  }
}
