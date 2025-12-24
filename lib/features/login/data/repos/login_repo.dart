import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginRepo {
  // دالة تسجيل الدخول
  Future<Either<String, UserCredential>> login({
    required String email,
    required String password,
  });

  // دالة تسجيل الخروج (الإضافة الجديدة)
  Future<Either<String, Unit>> logout();
}