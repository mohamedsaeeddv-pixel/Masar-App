import 'package:dartz/dartz.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import '../../../../core/errors/failures.dart';

abstract class TaskRepository {
  /// Get all orders assigned to a representative
  Future<Either<Failure, List<TaskModel>>> getDailyTasks({
    required String representativeId,
  });

  /// Get a single order by its ID
  Future<Either<Failure, TaskModel>> getOrderById({
    required String representativeId,
    required String orderId,
  });
}
