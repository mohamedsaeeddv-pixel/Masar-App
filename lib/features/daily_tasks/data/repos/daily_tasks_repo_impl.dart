import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import 'daily_tasks_repo.dart';

class DailyTasksRepoImpl implements DailyTasksRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<TaskModel>> fetchTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}