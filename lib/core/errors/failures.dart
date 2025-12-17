
import 'package:firebase_core/firebase_core.dart';

// core/error/failure.dart
abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });
}

// core/error/firebase_failure.dart

class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code,
  });

  /// Convert any FirebaseException to FirebaseFailure
  factory FirebaseFailure.fromException(FirebaseException e) {
    switch (e.code) {
      // Network
      case 'network-request-failed':
        return const FirebaseFailure(
          message: 'No internet connection',
          code: 'network-request-failed',
        );

      // Permission
      case 'permission-denied':
        return const FirebaseFailure(
          message: 'Permission denied',
          code: 'permission-denied',
        );

      // Auth
      case 'user-not-found':
        return const FirebaseFailure(
          message: 'User not found',
          code: 'user-not-found',
        );

      case 'wrong-password':
        return const FirebaseFailure(
          message: 'Incorrect password',
          code: 'wrong-password',
        );

      case 'email-already-in-use':
        return const FirebaseFailure(
          message: 'Email already in use',
          code: 'email-already-in-use',
        );

      case 'invalid-email':
        return const FirebaseFailure(
          message: 'Invalid email address',
          code: 'invalid-email',
        );

      case 'weak-password':
        return const FirebaseFailure(
          message: 'Password is too weak',
          code: 'weak-password',
        );

      // Default
      default:
        return FirebaseFailure(
          message: e.message ?? 'Unknown Firebase error',
          code: e.code,
        );
    }
  }
}
