import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_model.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<ProfileModel> getProfileData() async {
    try {
      // 1. الحصول على الـ ID بتاع المستخدم المسجل حالياً
      String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        throw Exception("المستخدم غير مسجل دخول");
      }

      // 2. الذهاب لـ collection الـ users ومقارنة الـ Document ID
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        // 3. تحويل البيانات لـ ProfileModel (تأكد أن الـ Model فيه fromJson)
        return ProfileModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("بيانات المستخدم غير موجودة");
      }
    } catch (e) {
      throw Exception("خطأ في جلب البيانات: ${e.toString()}");
    }
  }
}