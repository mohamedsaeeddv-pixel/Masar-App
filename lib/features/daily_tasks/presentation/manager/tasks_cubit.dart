import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/daily_tasks_repo.dart';
import '../../data/models/task_model.dart';

// States (نفس اللي عملناها)
abstract class TasksState {}
class TasksInitial extends TasksState {}
class TasksLoading extends TasksState {}
class TasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  TasksSuccess(this.tasks);
}
class TasksError extends TasksState {
  final String message;
  TasksError(this.message);
}

class TasksCubit extends Cubit<TasksState> {
  final DailyTasksRepo tasksRepo; // حقن الـ Repo هنا

  TasksCubit(this.tasksRepo) : super(TasksInitial());

  void getTasks() {
    emit(TasksLoading());
    // بنعمل listen للـ Stream اللي جاي من الـ Repo
    tasksRepo.fetchTasks().listen(
          (tasks) {
        emit(TasksSuccess(tasks));
      },
      onError: (error) {
        emit(TasksError(error.toString()));
      },
    );
  }
}