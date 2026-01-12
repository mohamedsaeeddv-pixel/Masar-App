import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/daily_tasks/data/repos/daily_tasks_repo.dart';
import 'package:masar_app/features/daily_tasks/presentation/manager/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskRepository repository;
  final String representativeId;

  TasksCubit({
    required this.repository,
    required this.representativeId,
  }) : super(const TasksInitial());

  /// جلب الطلبات الخاصة بالمندوب
  Future<void> getTasks() async {
    emit(const TasksLoading());

    final Either<Failure, List<TaskModel>> result =
        await repository.getDailyTasks(
          representativeId: representativeId,
        );

    result.fold(
      (failure) => emit(TasksFailure(failure.errorMessage)),
      (tasks) => emit(TasksSuccess(tasks)),
    );
  }
}
