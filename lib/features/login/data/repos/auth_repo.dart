import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/login/data/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> logout();

  /// Get the UID of the currently logged-in user, or null if not logged in
  String? currentUid();
}