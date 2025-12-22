import 'package:firebase_auth/firebase_auth.dart';
class UserModel {
  final String uid;        // Firebase UID (Primary Key)
  final String identifier; // Email أو Username

  UserModel({
    required this.uid,
    required this.identifier,
  });

  factory UserModel.fromAuth(User user) {
    return UserModel(
      uid: user.uid,
      identifier: user.email ?? '',
    );
  }
}
