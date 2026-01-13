import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart'; // عشان نعرف اللغة الحالية
import '../models/dashboard_model.dart';

class DashboardRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<DashboardModel> getDashboardData() {
    String uid = _auth.currentUser?.uid ?? '';

    // بنستخدم asyncMap عشان نجيب بيانات المستخدم من كولكشن الـ users الأول
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((userDoc) async {

      // سحب الأسماء من كولكشن الـ users
      String nameAr = userDoc.data()?['nameAr'] ?? "مندوب";
      String nameEn = userDoc.data()?['nameEn'] ?? "Representative";

      // تحديد اللغة الحالية عشان نختار الاسم الصح
      // لو اللغة عربي هناخد nameAr، غير كدة nameEn
      String currentName = Intl.getCurrentLocale() == 'ar' ? nameAr : nameEn;

      // سحب طلبات المندوب من مكانه الأصلي
      var snapshot = await _firestore
          .collection('representative')
          .doc(uid)
          .collection('orders')
          .get();

      // 1. حساب الأرقام الأساسية من الداتا الحقيقية
      int total = snapshot.docs.length;
      int delivered = snapshot.docs.where((doc) => doc.data()['status'] == 'completed').length;
      int returned = snapshot.docs.where((doc) => doc.data()['status'] == 'returned').length;
      int failed = snapshot.docs.where((doc) => doc.data()['status'] == 'failed').length;

      // 2. حساب النسب المئوية للشارت
      double deliveredP = total > 0 ? (delivered / total) * 100 : 0;
      double returnedP = total > 0 ? (returned / total) * 100 : 0;
      double failedP = total > 0 ? (failed / total) * 100 : 0;

      // بنرجع الموديل بتاعك بنفس أسماء المتغيرات بتاعته بالظبط
      return DashboardModel(
        userName: currentName, // الاسم اللي اخترناه بناءً على اللغة
        receivedOrders: total,
        deliveredOrders: delivered,
        weeklyCompletedTasks: delivered,
        deliveredPercent: deliveredP,
        returnedPercent: returnedP,
        failedPercent: failedP,
      );
    });
  }
}