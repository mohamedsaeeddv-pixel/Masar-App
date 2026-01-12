import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String errorMessage;
  final String? code;

  const Failure({
    required this.errorMessage,
    this.code,
  });
}

// ضفنا الـ ServerFailure اللي الـ Repo بينادي عليه بنفس الـ Property name
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(errorMessage: message);
}

/// Firebase-specific failures
class FirebaseAuthFailure extends Failure {
  const FirebaseAuthFailure({
    required super.errorMessage,
    super.code,
  });

  factory FirebaseAuthFailure.fromAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return const FirebaseAuthFailure(
          errorMessage: 'لا يوجد اتصال بالإنترنت',
          code: 'network-request-failed',
        );
      case 'user-not-found':
        return const FirebaseAuthFailure(
          errorMessage: 'المستخدم غير موجود',
          code: 'user-not-found',
        );
      case 'wrong-password':
        return const FirebaseAuthFailure(
          errorMessage: 'كلمة المرور غير صحيحة',
          code: 'wrong-password',
        );
    // ... باقي الـ cases اللي إنت كاتبها سيبتها زي ما هي بالظبط
      default:
        return FirebaseAuthFailure(
          errorMessage: e.message ?? 'حدث خطأ غير متوقع',
          code: e.code,
        );
    }
  }
}

/// Generic Firebase failures
class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.errorMessage,
    super.code,
  });

  factory FirebaseFailure.fromException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const FirebaseFailure(
          errorMessage: 'ليس لديك صلاحية الوصول',
          code: 'permission-denied',
        );
      default:
        return FirebaseFailure(
          errorMessage: e.message ?? 'حدث خطأ غير متوقع',
          code: e.code,
        );
    }
  }
}