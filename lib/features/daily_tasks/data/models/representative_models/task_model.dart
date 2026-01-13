import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/product_task_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_area_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_client_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_type_model.dart';
class TaskModel {
  final String id; // مهم
  final AreaModel area;
  final ClientTaskModel client;
  final List<ProductTaskModel> products;
  final TaskTypeModel taskType;
  final int totalPrice;
  final DateTime createdAt;
  final String? representativeId;
  final TaskStatus status;
  final DateTime? updatedAt;

  TaskModel({
    required this.id,
    required this.area,
    required this.client,
    required this.products,
    required this.taskType,
    required this.totalPrice,
    required this.createdAt,
    this.representativeId,
    this.status = TaskStatus.assigned,
    this.updatedAt,
  });

TaskModel copyWith({
    String? id,
    AreaModel? area,
    ClientTaskModel? client,
    List<ProductTaskModel>? products,
    TaskTypeModel? taskType,
    int? totalPrice,
    DateTime? createdAt,
    String? representativeId,
    TaskStatus? status,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      area: area ?? this.area,
      client: client ?? this.client,
      products: products ?? this.products,
      taskType: taskType ?? this.taskType,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      representativeId: representativeId ?? this.representativeId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      area: AreaModel.fromMap(map['area']),
      client: ClientTaskModel.fromMap(map['customer']),
      products: (map['products'] as List)
          .map((e) => ProductTaskModel.fromMap(e))
          .toList(),
      taskType: TaskTypeModel.fromMap(map['taskType']),
      totalPrice: map['totalPrice'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      representativeId: map['representativeId'],
      status: TaskStatusX.fromString(map['status'] ?? 'assigned'),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory TaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data()!;
    return TaskModel(
      id: doc.id,
      area: AreaModel.fromMap(map['area']),
      client: ClientTaskModel.fromMap(map['customer']),
      products: (map['products'] as List)
          .map((e) => ProductTaskModel.fromMap(e))
          .toList(),
      taskType: TaskTypeModel.fromMap(map['taskType']),
      totalPrice: map['totalPrice'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      representativeId: map['representativeId'],
      status: TaskStatusX.fromString(map['status'] ?? 'assigned'),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'area': area.toMap(),
      'customer': client.toMap(),
      'products': products.map((e) => e.toMap()).toList(),
      'taskType': taskType.toMap(),
      'totalPrice': totalPrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'representativeId': representativeId,
      'status': status.name,
      'updatedAt':
          updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
enum TaskStatus {
  assigned,
  completed,
  newOrder,
  failed,
  
}
enum TaskSatusText {
  assigned('assigned'),
  completed('completed'),
  newOrder('new'),
  failed('failed');


  final String label;
  const TaskSatusText(this.label);
}

extension TaskStatusX on TaskStatus {
  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TaskStatus.assigned,
    );
  }
}
