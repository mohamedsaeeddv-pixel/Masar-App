import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'login_repo.dart';

class LoginRepoImpl implements LoginRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<String, UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left("هذا البريد الإلكتروني غير مسجل لدينا");
      } else if (e.code == 'wrong-password') {
        return left("كلمة المرور غير صحيحة");
      } else if (e.code == 'invalid-email') {
        return left("صيغة البريد الإلكتروني غير صحيحة");
      }
      return left(e.message ?? "حدث خطأ في المصادقة");
    } catch (e) {
      return left("حدث خطأ غير متوقع، حاول لاحقاً");
    }
  }

  // --- إضافة دالة تسجيل الخروج ---
  @override
  Future<Either<String, Unit>> logout() async {
    try {
      await _auth.signOut();
      return right(unit); //
    } catch (e) {
      return left("فشل في تسجيل الخروج، يرجى المحاولة مرة أخرى");
    }
  }
}