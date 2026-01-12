import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';

abstract class TasksState {
  const TasksState();
}

class TasksInitial extends TasksState {
  const TasksInitial();
}

class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksSuccess extends TasksState {
  final List<TaskModel> tasks;

  const TasksSuccess(this.tasks);
}

class TasksFailure extends TasksState {
  final String message;

  const TasksFailure(this.message);
}
