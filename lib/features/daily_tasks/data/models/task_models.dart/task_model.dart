import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/agent_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_area_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/task_models.dart/task_client_model.dart';

class TaskModel {
  final String id;
  final String status;
  final String taskType;
  final int totalPrice;
  final DateTime createdAt;
  final AgentModel agent;
  final AreaModel area;
  final List<TaskClientModel> customers;

  TaskModel({
    required this.id,
    required this.status,
    required this.taskType,
    required this.totalPrice,
    required this.createdAt,
    required this.agent,
    required this.area,
    required this.customers,
  });

  factory TaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return TaskModel(
      id: doc.id,
      status: data['status'] ?? '',
      taskType: data['taskType'] ?? '',
      totalPrice: (data['totalPrice'] ?? 0) as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      agent: AgentModel.fromMap(data['agent']),
      area: AreaModel.fromMap(data['area']),
      customers: (data['customers'] as List<dynamic>? ?? [])
          .map((e) => TaskClientModel.fromMap(e))
          .toList(),
    );
  }
}
