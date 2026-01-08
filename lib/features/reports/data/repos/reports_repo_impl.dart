import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/reports_model.dart';
import './reports_repo.dart';

class ReportsRepoImpl implements ReportsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<ReportsModel> getReportsData(String period) {
    String uid = _auth.currentUser?.uid ?? '';

    return _firestore
        .collection('representative')
        .doc(uid)
        .collection('orders')
        .snapshots() // التحديث التلقائي اللحظي
        .map((ordersSnapshot) {

      // 1. تحديد التارجت بناءً على الفترة (الشهر 20 يوم عمل)
      int totalOrdersGoal;
      double totalSalesGoal;

      // بنقارن بالقيم اللي جاية من الـ UI (يومي، أسبوعي، شهري)
      if (period == 'يومي') {
        totalOrdersGoal = 5;      // 100 طلب ÷ 20 يوم
        totalSalesGoal = 1500;    // 30,000 جنيه ÷ 20 يوم
      } else if (period == 'أسبوعي') {
        totalOrdersGoal = 25;     // 100 طلب ÷ 4 أسابيع
        totalSalesGoal = 7500;    // 30,000 جنيه ÷ 4 أسابيع
      } else {
        // الافتراضي "شهري"
        totalOrdersGoal = 100;
        totalSalesGoal = 30000;
      }

      double totalSales = 0;
      int completedCount = 0;
      double totalDistance = 0;

      for (var doc in ordersSnapshot.docs) {
        var data = doc.data();

        // 2. فلترة الأوردرات المكتملة فقط
        if (data['status'] == 'completed') {
          completedCount++;

          // حساب المبيعات
          if (data['totalPrice'] != null) {
            totalSales += (data['totalPrice'] as num).toDouble();
          } else if (data['products'] != null) {
            var products = data['products'] as List<dynamic>;
            for (var item in products) {
              totalSales += (item['price'] as num? ?? 0).toDouble();
            }
          }

          // حساب المسافة
          totalDistance += (data['distance'] as num? ?? 0).toDouble();
        }
      }

      // 3. إرجاع الموديل بالقيم المحسوبة
      return ReportsModel(
        completedOrders: completedCount,
        totalOrdersGoal: totalOrdersGoal,
        salesAmount: totalSales,
        totalSalesGoal: totalSalesGoal,
        distanceKm: totalDistance > 0 ? totalDistance : 850.0,
        reportPeriod: period,
      );
    });
  }
}