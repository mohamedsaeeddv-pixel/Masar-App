import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_client_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_model.dart';

class TaskWithCustomer {
  final TaskModel task;
  final TaskClientModel customer;

  TaskWithCustomer({
    required this.task,
    required this.customer,
  });
}
