import 'package:dartz/dartz.dart';
import '../models/task_model.dart';

abstract class DailyTasksRepo {
  // بنستخدم Stream عشان البيانات تتحدث تلقائياً أول ما تتغير في Firebase
  Stream<List<TaskModel>> fetchTasks();

// ممكن تضيف دوال تانية مستقبلاً زي:
// Future<Either<Failure, void>> completeTask(String taskId);
}