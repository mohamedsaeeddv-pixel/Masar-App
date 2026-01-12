import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';

abstract class OrderRepository {
  Future<Either<Failure, Unit>> addNewOrder(TaskModel task);
  Future<Either<Failure, Unit>> updateOrderStatus(
    TaskModel task,
    TaskStatus newStatus,
  );
}
