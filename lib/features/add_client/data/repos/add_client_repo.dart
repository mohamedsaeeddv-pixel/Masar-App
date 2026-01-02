import '../../../../core/shared_models/client_model.dart';

abstract class AddClientRepo {
  Future<void> addClient(ClientModel client);
}