import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/home/data/repos/order_repo.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore firestore;

  OrderRepositoryImpl({required this.firestore});

  // =========================
  // 1️⃣ إضافة طلب جديد
  // =========================
  @override
  Future<Either<Failure, Unit>> addNewOrder(TaskModel task) async {
    try {
      if (task.id.isEmpty) {
        return Left(FirebaseFailure(errorMessage: 'معرف الطلب فارغ'));
      }

      final newOrderRef =
          firestore.collection('new_order').doc(task.id);

      await newOrderRef.set({
        ...task.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': TaskSatusText.newOrder.label,
      });

      return const Right(unit);

    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(
        FirebaseFailure(errorMessage: 'حدث خطأ غير متوقع : $e'),
      );
    }
  }

  // =========================
  // 2️⃣ تعديل حالة الطلب
  // =========================
  @override
  Future<Either<Failure, Unit>> updateOrderStatus(
    TaskModel task,
    TaskStatus newStatus,
  ) async {
    try {
      if (task.id.isEmpty) {
        return Left(FirebaseFailure(errorMessage: 'معرف الطلب فارغ'));
      }

      if (task.representativeId == null ||
          task.representativeId!.isEmpty) {
        return Left(
          FirebaseFailure(errorMessage: 'معرف المندوب غير موجود'),
        );
      }

      final batch = firestore.batch();

      // collection العامة
      final orderRef =
          firestore.collection('orders').doc(task.id);

      // subcollection عند المندوب
      final repOrderRef = firestore
          .collection('representative')
          .doc(task.representativeId)
          .collection('orders')
          .doc(task.id);

      final updateData = {
        'status': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      batch.update(orderRef, updateData);
      batch.update(repOrderRef, updateData);

      await batch.commit();

      return const Right(unit);

    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(
        FirebaseFailure(errorMessage: 'حدث خطأ غير متوقع : $e'),
      );
    }
  }
}
