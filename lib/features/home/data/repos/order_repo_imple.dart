import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/home/data/models/order_action_model.dart';
import 'package:masar_app/features/home/data/repos/order_repo.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore firestore;

  OrderRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, Unit>> sendOrderAction(
    OrderActionModel actionModel,
  ) async {
    try {
      final orderDoc = firestore.collection('orders').doc(actionModel.orderId);

      // محاولة إضافة الطلب الرئيسي
      await orderDoc.set({
        'clientId': actionModel.clientId,
        'agentId': actionModel.agentId,
        'quantity': actionModel.quantity,
        'status': actionModel.type.name,
        'timestamp': actionModel.timestamp.toIso8601String(),
        'notes': actionModel.notes,
        'productName': actionModel.productName,
        'productPrice': actionModel.productPrice,
      }, SetOptions(merge: true));

      // محاولة إضافة سجل التاريخ (فشلها لن يمنع نجاح الطلب)
      try {
        await orderDoc.collection('history').add(actionModel.toMap());
      } catch (e) {
        print('Warning: failed to add history for order ${actionModel.orderId} -> $e');
      }

      return const Right(unit);

    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromAuthException(e));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return const Left(FirebaseFailure(errorMessage: 'حدث خطأ غير متوقع'));
    }
  }
}
