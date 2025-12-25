import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/login_repo.dart';

abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(LoginInitial());

  Future<void> loginUser({required String email, required String password}) async {
    emit(LoginLoading());

    final result = await loginRepo.login(email: email, password: password);

    result.fold(
          (failure) {
        emit(LoginFailure(failure));
      },
          (userCredential) {
        emit(LoginSuccess());
      },
    );
  }
}