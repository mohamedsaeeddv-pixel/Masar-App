import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_client_repo.dart';
import '../models/client_model.dart';

class AddClientRepoImpl implements AddClientRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addClient(ClientModel client) async {
    final docRef = _firestore.collection('customers').doc();

    await docRef.set(client.toMap());
  }
}
