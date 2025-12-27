import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/login/data/models/user_model.dart';
import 'package:masar_app/features/login/data/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';
part 'auth_states.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthCubitInitial());

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    emit(AuthCubitLoading());

    final Either<Failure, UserModel> result =
        await authRepo.login(email: email, password: password);

    result.fold(
      (failure) => emit(AuthCubitError(failure.message)),
      (user) => emit(AuthCubitAuthenticated(user)),
    );
  }

  /// Logout the current user
  Future<void> logout() async {
    emit(AuthCubitLoading());

    final Either<Failure, void> result = await authRepo.logout();

    result.fold(
      (failure) => emit(AuthCubitError(failure.message)),
      (_) => emit(AuthCubitUnauthenticated()),
    );
  }

  /// Check if a user is already logged in
  Future<void> checkAuth() async {
    emit(AuthCubitLoading());

    final Either<Failure, bool> result = await authRepo.isLoggedIn();

    result.fold(
      (failure) => emit(AuthCubitError(failure.message)),
      (isLoggedIn) {
        if (isLoggedIn) {
          // Optional: you can fetch the UserModel from cache or Firebase here
          emit(AuthCubitAuthenticated(
              UserModel(uid: authRepo.currentUid()!, identifier: ''))); 
        } else {
          emit(AuthCubitUnauthenticated());
        }
      },
    );
  }
}