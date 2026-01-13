import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/deal_model.dart';
import 'deals_repo.dart';

class DealsRepoImpl implements DealsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<List<DealModel>> fetchDeals() {
    String uid = _auth.currentUser?.uid ?? '';

    return _firestore
        .collection('representative')
        .doc(uid)
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // 1. الدخول جوه خريطة العميل لسحب البيانات
        final customerData = data['customer'] as Map<String, dynamic>?;

        // 2. الدخول جوه خريطة المنطقة لسحب العنوان
        final areaData = data['area'] as Map<String, dynamic>?;

        // 3. سحب بيانات نوع المهمة لاستخدامها كعنوان (استرجاع/استلام)
        final taskData = data['taskType'] as Map<String, dynamic>?;
        String taskTitle = taskData?['label'] ?? 'طلب جديد'; // سيظهر "استرجاع" أو "استلام"

        // 4. تحويل الحالة لنص عربي
        String rawStatus = data['status']?.toString().trim() ?? 'assigned';
        String displayStatus = (rawStatus == 'completed') ? 'تمت' : (rawStatus == 'assigned' ? 'قيد الانتظار' : 'فشل');

        return DealModel(
          dealId: doc.id,
          customerId: customerData?['id'] ?? 'CUST-0000',
          customerName: customerData?['name'] ?? 'غير معروف',
          amount: "${data['totalPrice'] ?? 0} جنيه",
          status: displayStatus,
          location: areaData?['name'] ?? 'القاهرة',
          phone: customerData?['phone'] ?? 'لا يوجد رقم',
          taskTitle: taskTitle, // إرسال العنوان الجديد للموديل
        );
      }).toList();
    });
  }
}