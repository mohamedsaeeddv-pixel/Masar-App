part of 'auth_cubit.dart';


// Base class for all Auth states


sealed class AuthCubitState extends Equatable {
  const AuthCubitState();

  @override
  List<Object> get props => [];
}

// Initial state when the Cubit is first created
final class AuthCubitInitial extends AuthCubitState {}

// Loading state while an authentication operation is in progress
final class AuthCubitLoading extends AuthCubitState {}

// Authenticated state when login succeeds
final class AuthCubitAuthenticated extends AuthCubitState {
  final UserModel user; // The logged-in user

  const AuthCubitAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

// Unauthenticated state when the user is not logged in
final class AuthCubitUnauthenticated extends AuthCubitState {}

// Error state when something goes wrong
final class AuthCubitError extends AuthCubitState {
  final String message; // Error message to display

  const AuthCubitError(this.message);

  @override
  List<Object> get props => [message];
}