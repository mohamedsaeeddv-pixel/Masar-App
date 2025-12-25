import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });
}

/// Firebase-specific failures
class FirebaseAuthFailure extends Failure {
  const FirebaseAuthFailure({
    required super.message,
    super.code,
  });

// core/error/firebase_failure.dart

  /// Handle all FirebaseAuthException codes
  factory FirebaseAuthFailure.fromAuthException(FirebaseAuthException e) {
    switch (e.code) {
      // ===== Network =====
      case 'network-request-failed':
        return const FirebaseAuthFailure(
          message: 'لا يوجد اتصال بالإنترنت',
          code: 'network-request-failed',
        );

      // ===== Auth =====
      case 'user-not-found':
        return const FirebaseAuthFailure(
          message: 'المستخدم غير موجود',
          code: 'user-not-found',
        );

      case 'wrong-password':
        return const FirebaseAuthFailure(
          message: 'كلمة المرور غير صحيحة',
          code: 'wrong-password',
        );

      case 'invalid-email':
        return const FirebaseAuthFailure(
          message: 'صيغة البريد الإلكتروني غير صحيحة',
          code: 'invalid-email',
        );

      case 'user-disabled':
        return const FirebaseAuthFailure(
          message: 'تم تعطيل هذا الحساب',
          code: 'user-disabled',
        );

      case 'too-many-requests':
        return const FirebaseAuthFailure(
          message: 'محاولات كثيرة، حاول لاحقًا',
          code: 'too-many-requests',
        );

      case 'email-already-in-use':
        return const FirebaseAuthFailure(
          message: 'البريد مستخدم بالفعل',
          code: 'email-already-in-use',
        );

      case 'weak-password':
        return const FirebaseAuthFailure(
          message: 'كلمة المرور ضعيفة',
          code: 'weak-password',
        );

        case 'invalid-credential':
      return const FirebaseAuthFailure(message: 'البيانات المقدمة غير صالحة أو منتهية الصلاحية', code: 'invalid-credential');

      // ===== Default =====
      default:
        return FirebaseAuthFailure(
          message: e.message ?? 'حدث خطأ غير متوقع',
          code: e.code,
        );
    }
  }
}

/// Generic Firebase failures (Firestore, Storage, etc.)
class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code,
  });

  /// Handle all other FirebaseException codes
  factory FirebaseFailure.fromException(FirebaseException e) {
    switch (e.code) {
      // ===== Network =====
      case 'network-request-failed':
        return const FirebaseFailure(
          message: 'لا يوجد اتصال بالإنترنت',
          code: 'network-request-failed',
        );

      // ===== Firestore =====
      case 'permission-denied':
        return const FirebaseFailure(
          message: 'ليس لديك صلاحية الوصول',
          code: 'permission-denied',
        );

      case 'not-found':
        return const FirebaseFailure(
          message: 'البيانات غير موجودة',
          code: 'not-found',
        );

      case 'unavailable':
        return const FirebaseFailure(
          message: 'الخدمة غير متاحة حاليًا',
          code: 'unavailable',
        );

      // ===== Default =====
      default:
        return FirebaseFailure(
          message: e.message ?? 'حدث خطأ غير متوقع',
          code: e.code,
        );
    }
  }

}


