import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_client_repo.dart';
import '../models/client_model.dart';

class AddClientRepoImpl implements AddClientRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  @override
  Future<void> addClient(ClientModel client) async {
    // غيرنا toJson() لـ toMap() عشان تطابق الـ Model بتاعك
    await _firestore.collection('customers').add(client.toMap());
  }
}