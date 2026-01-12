import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/daily_tasks/data/repos/daily_tasks_repo.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, List<TaskModel>>> getDailyTasks({
    required String representativeId,
  }) async {
    try {
      final snapshot = await firestore
          .collection('representative')
          .doc(representativeId)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs.map((doc) {
        final task = TaskModel.fromMap(doc.data());
        return task.copyWith(id: doc.id); // <-- هنا بتحط الـ doc.id
      }).toList();

      debugPrint(
        'Fetched ${orders.length} orders for representative $representativeId',
      );

      return Right(orders);
    }
    // 🔴 Firestore / Firebase errors
    on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.message}');
      return Left(FirebaseFailure.fromException(e));
    }
    // 🔴 Any unexpected error
    catch (e) {
      debugPrint('FirebaseException: ${e.toString()}');
      return const Left(FirebaseFailure(errorMessage: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, TaskModel>> getOrderById({
    required String representativeId,
    required String orderId,
  }) async {
    try {
      final doc = await firestore
          .collection('representative')
          .doc(representativeId)
          .collection('orders')
          .doc(orderId)
          .get();

      if (!doc.exists) {
        return const Left(
          FirebaseFailure(errorMessage: 'الطلب غير موجود', code: 'not-found'),
        );
      }

      return Right(TaskModel.fromMap(doc.data()!));
    }
    // 🔴 Firestore / Firebase errors
    on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    }
    // 🔴 Any unexpected error
    catch (e) {
      return const Left(FirebaseFailure(errorMessage: 'حدث خطأ غير متوقع'));
    }
  }
}
