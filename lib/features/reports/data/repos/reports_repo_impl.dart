import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart'; // مهم جداً للغة
import '../models/reports_model.dart';
import './reports_repo.dart';

class ReportsRepoImpl implements ReportsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<ReportsModel> getReportsData(String period) {
    String uid = _auth.currentUser?.uid ?? '';

    // 1. نبدأ بمراقبة بيانات المستخدم من collection الـ users
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((userSnapshot) async {

      // جلب الأسماء من Firestore
      Map<String, dynamic>? userData = userSnapshot.data();
      String nameAr = userData?['nameAr'] ?? "مندوب";
      String nameEn = userData?['nameEn'] ?? "Representative";

      // اختيار الاسم بناءً على لغة التطبيق الحالية
      String currentName = Intl.getCurrentLocale() == 'ar' ? nameAr : nameEn;

      // 2. جلب طلبات المندوب (المنطق الأصلي بتاعك)
      var ordersSnapshot = await _firestore
          .collection('representative')
          .doc(uid)
          .collection('orders')
          .get();

      // --- حساب التارجت (من كودك الأصلي) ---
      int totalOrdersGoal;
      double totalSalesGoal;

      if (period == 'يومي') {
        totalOrdersGoal = 5;
        totalSalesGoal = 1500;
      } else if (period == 'أسبوعي') {
        totalOrdersGoal = 25;
        totalSalesGoal = 7500;
      } else {
        totalOrdersGoal = 100;
        totalSalesGoal = 30000;
      }

      double totalSales = 0;
      int completedTasksCount = 0;
      double totalDistance = 0;

      for (var doc in ordersSnapshot.docs) {
        var data = doc.data();
        String status = data['status']?.toString().trim() ?? '';

        var taskTypeData = data['taskType'];
        String taskTypeKey = '';

        if (taskTypeData is Map) {
          taskTypeKey = taskTypeData['key']?.toString() ?? '';
        } else {
          taskTypeKey = taskTypeData?.toString() ?? '';
        }

        if (status == 'completed') {
          completedTasksCount++;

          if (taskTypeKey != 'return') {
            if (data['totalPrice'] != null) {
              totalSales += (data['totalPrice'] as num).toDouble();
            } else if (data['products'] != null) {
              var products = data['products'] as List<dynamic>;
              for (var item in products) {
                totalSales += (item['price'] as num? ?? 0).toDouble();
              }
            }
          }
        }
      }

      // 3. إرجاع الموديل بكل البيانات + الاسم اللي جبناه (حل الـ Error)
      return ReportsModel(
        userName: currentName, // أضفنا الاسم هنا
        completedOrders: completedTasksCount,
        totalOrdersGoal: totalOrdersGoal,
        salesAmount: totalSales,
        totalSalesGoal: totalSalesGoal,
        distanceKm: totalDistance > 0 ? totalDistance : 850.0,
        reportPeriod: period,
      );
    });
  }
}