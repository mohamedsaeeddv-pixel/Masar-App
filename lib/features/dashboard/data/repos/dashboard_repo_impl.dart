import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart'; // مهم عشان اللغة
import '../models/dashboard_model.dart';

class DashboardRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<DashboardModel> getDashboardData() {
    String uid = _auth.currentUser?.uid ?? '';

    // 1. نبدأ بمراقبة بيانات المستخدم من collection الـ users
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((userSnapshot) async {

      // 2. استخراج البيانات والاسم حسب لغة التطبيق الحالية
      Map<String, dynamic>? userData = userSnapshot.data();

      // هنا حددنا اللغة ديناميكياً باستخدام Intl الخاص بـ easy_localization
      String currentLang = Intl.getCurrentLocale();

      String nameAr = userData?['nameAr'] ?? "مندوب";
      String nameEn = userData?['nameEn'] ?? "Representative";

      // اختيار الاسم اللي هيروح لـ userName في الموديل
      String chosenName = (currentLang == 'ar') ? nameAr : nameEn;

      // 3. ننتقل الآن لجلب طلبات المندوب (المنطق بتاعك زي ما هو)
      var ordersSnapshot = await _firestore
          .collection('representative')
          .doc(uid)
          .collection('orders')
          .get();

      final filteredDocs = ordersSnapshot.docs.where((doc) {
        String type = doc.data()['taskType']?.toString().trim().toLowerCase() ?? '';
        return type == 'deliver' || type == 'return';
      }).toList();

      int total = filteredDocs.length;
      DateTime weekAgo = DateTime.now().subtract(const Duration(days: 7));

      int delivered = filteredDocs.where((doc) {
        String status = doc.data()['status']?.toString().trim() ?? '';
        return status == 'completed';
      }).length;

      int weeklyTasks = filteredDocs.where((doc) {
        var data = doc.data();
        String status = data['status']?.toString().trim() ?? '';
        if (status == 'completed' && data['createdAt'] != null) {
          DateTime orderDate = (data['createdAt'] as Timestamp).toDate();
          return orderDate.isAfter(weekAgo);
        }
        return false;
      }).length;

      int returned = filteredDocs.where((doc) => doc.data()['status'] == 'returned').length;
      int failed = filteredDocs.where((doc) => doc.data()['status'] == 'failed').length;

      double deliveredP = total > 0 ? (delivered / total) * 100 : 0;
      double returnedP = total > 0 ? (returned / total) * 100 : 0;
      double failedP = total > 0 ? (failed / total) * 100 : 0;

      return DashboardModel(
        userName: chosenName,
        receivedOrders: total,
        deliveredOrders: delivered,
        weeklyCompletedTasks: weeklyTasks,
        deliveredPercent: deliveredP,
        returnedPercent: returnedP,
        failedPercent: failedP,
      );
    });
  }
}