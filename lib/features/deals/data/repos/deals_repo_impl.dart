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

        String rawStatus = data['status'] ?? 'assigned';
        String displayStatus;

        if (rawStatus == 'completed') {
          displayStatus = 'تمت';
        } else if (rawStatus == 'assigned') {
          displayStatus = 'قيد الانتظار';
        } else if (rawStatus == 'failed') {
          displayStatus = 'فشل';
        } else {
          displayStatus = rawStatus;
        }

        return DealModel(
          dealId: doc.id,
          customerId: data['customerId'] ?? 'CUST-0000',
          customerName: data['customerName'] ?? 'غير معروف',
          // المبلغ يظهر بالجنيه كما في التصميم
          amount: "${data['totalPrice'] ?? 0} جنيه",
          status: displayStatus,
          location: data['address'] ?? 'القاهرة',
          phone: data['phone'] ?? '',
        );
      }).toList();
    });
  }
}