import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_and_customer_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_model.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksSuccess extends TasksState {
  final List<TaskModel> tasks;
    final List<TaskWithCustomer> customerTasks;

  TasksSuccess({this.tasks = const [], this.customerTasks = const []});
}

class TasksFailure extends TasksState {
  final String message;
  TasksFailure(this.message);
}
