import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_and_customer_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_model.dart';
import 'package:masar_app/features/daily_tasks/data/repos/daily_tasks_repo.dart';
import 'package:masar_app/features/daily_tasks/presentation/manager/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskRepository repository;
  final String agentId;

  TasksCubit({
    required this.repository,
    required this.agentId,
  }) : super(TasksInitial());

  /// جلب المهام الرئيسية (TaskModel)
  Future<void> getTasks() async {
    emit(TasksLoading());

    final Either<Failure, List<TaskModel>> result =
        await repository.getDailyTasks(agentId: agentId);

    result.fold(
      (failure) => emit(TasksFailure(failure.errorMessage)),
      (tasks) {
       
        emit(TasksSuccess(tasks: tasks));
      },
    );
  }

  /// جلب العملاء لكل مهمة (TaskClientModel)
  Future<void> fetchCustomerTasks() async {
    emit(TasksLoading());

    final Either<Failure, List<TaskWithCustomer>> result =
        await repository.getCustomerTasks(agentId: agentId);

    result.fold(
      (failure) => emit(TasksFailure(failure.errorMessage)),
      (customerTasks) {
        // نحتفظ بالـ tasks الحالي لو موجود
        List<TaskModel> tasks = [];
        if (state is TasksSuccess) {
          tasks = (state as TasksSuccess).tasks;

        }
        emit(TasksSuccess(tasks: tasks, customerTasks: customerTasks));
      },
    );
  }
}
