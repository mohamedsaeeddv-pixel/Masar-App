import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/dashboard_model.dart';

class DashboardRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<DashboardModel> getDashboardData() {
    String uid = _auth.currentUser?.uid ?? '';
    String name = _auth.currentUser?.displayName ?? "محمد";

    return _firestore
        .collection('representative')
        .doc(uid)
        .collection('orders')
        .snapshots()
        .map((snapshot) {

      // 1. إجمالي الطلبات
      int total = snapshot.docs.length;

      // 2. الطلبات المكتملة
      int delivered = snapshot.docs.where((doc) => doc.data()['status'] == 'completed').length;

      // 3. الطلبات الراجعة (لو عندك status اسمه returned)
      int returned = snapshot.docs.where((doc) => doc.data()['status'] == 'returned').length;

      // 4. الطلبات الفاشلة (لو عندك status اسمه failed)
      int failed = snapshot.docs.where((doc) => doc.data()['status'] == 'failed').length;

      // حساب النسب المئوية ديناميكياً
      double deliveredP = total > 0 ? (delivered / total) * 100 : 0;
      double returnedP = total > 0 ? (returned / total) * 100 : 0;
      double failedP = total > 0 ? (failed / total) * 100 : 0;

      return DashboardModel(
        userName: name,
        receivedOrders: total,
        deliveredOrders: delivered,
        weeklyCompletedTasks: delivered, // أو احسبها بناءً على تاريخ الأسبوع
        deliveredPercent: deliveredP,
        returnedPercent: returnedP,
        failedPercent: failedP,
      );
    });
  }
}