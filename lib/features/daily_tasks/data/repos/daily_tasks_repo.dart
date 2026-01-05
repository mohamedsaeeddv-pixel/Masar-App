import 'package:dartz/dartz.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_and_customer_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_model.dart';
import '../../../../core/errors/failures.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskModel>>> getDailyTasks({
    required String agentId,
  });

  Future<Either<Failure, TaskModel>> getTaskById({
    required String taskId,
  });

  Future<Either<Failure, List<TaskWithCustomer>>> getCustomerTasks({required String agentId});

}
