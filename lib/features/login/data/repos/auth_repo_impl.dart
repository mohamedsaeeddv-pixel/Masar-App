import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import '../models/user_model.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<FirebaseAuthFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return left(const FirebaseAuthFailure(
          errorMessage: 'فشل تسجيل الدخول',
          code: 'user-null',
        ));
      }

      return right(UserModel(uid: user.uid, identifier: user.email ?? ''));
    } on FirebaseAuthException catch (e) {
      return left(FirebaseAuthFailure.fromAuthException(e));
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseAuthFailure, bool>> isLoggedIn() async {
    try {
      return right(_auth.currentUser != null);
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseAuthFailure, void>> logout() async {
    try {
      await _auth.signOut();
      return right(null);
    } catch (e) {
      return left(FirebaseAuthFailure(errorMessage: e.toString()));
    }
  }

  @override
  String? currentUid() {
    return _auth.currentUser?.uid;
  }
}
