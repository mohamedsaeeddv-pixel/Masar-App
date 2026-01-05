import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_and_customer_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_model.dart';
import 'package:masar_app/features/daily_tasks/data/repos/daily_tasks_repo.dart';

import '../../../../core/errors/failures.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, List<TaskModel>>> getDailyTasks({
    required String agentId,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('tasks')
          .where('agent.id', isEqualTo: agentId)
          .where('status', isEqualTo: 'assigned')
          .orderBy('createdAt', descending: true)
          .get();

      final tasks = querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();

      return Right(tasks);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return const Left(
        FirebaseFailure(
          message: 'حدث خطأ غير متوقع أثناء تحميل المهام',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TaskModel>> getTaskById({
    required String taskId,
  }) async {
    try {
      final doc =
          await firestore.collection('tasks').doc(taskId).get();

      if (!doc.exists) {
        return const Left(
          FirebaseFailure(
            message: 'المهمة غير موجودة',
            code: 'not-found',
          ),
        );
      }

      return Right(TaskModel.fromFirestore(doc));
      } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return const Left(
        FirebaseFailure(
          message: 'حدث خطأ غير متوقع أثناء تحميل تفاصيل المهمة',
        ),
      );
    }
  }

@override
Future<Either<Failure, List<TaskWithCustomer>>> getCustomerTasks({required String agentId,}) async {
  try {
    final snapshot = await firestore
        .collection('tasks')
        .where('agent.id', isEqualTo: agentId)
        .where('status', isEqualTo: 'assigned')
        .orderBy('createdAt', descending: true)
        .get();

    final all = snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc))
        .expand((task) => task.customers.map(
              (c) => TaskWithCustomer(task: task, customer: c),
            ))
        .toList();
            print('Loaded ${all.length} customer tasks.');


    return Right(all);
  } on FirebaseException catch (e) {
    return Left(FirebaseFailure.fromException(e));
  } catch (e) {
    return const Left(FirebaseFailure(
      message: 'حدث خطأ غير متوقع أثناء تحميل تفاصيل المهمة',
    ));
  }
}

  }


