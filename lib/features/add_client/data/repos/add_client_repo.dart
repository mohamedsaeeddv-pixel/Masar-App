import '../models/client_model.dart';

abstract class AddClientRepo {
  Future<void> addClient(ClientModel client);
}