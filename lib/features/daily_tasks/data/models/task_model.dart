class TaskModel {
  final String id;
  final String taskName;
  final String clientName;
  final String location;
  final String price;
  final String time;
  final String type;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.clientName,
    required this.location,
    required this.price,
    required this.time,
    required this.type,
  });

  factory TaskModel.fromFirestore(Map<String, dynamic> json, String documentId) {
    return TaskModel(
      id: documentId,
      taskName: json['taskName'] ?? 'بدون عنوان',
      clientName: json['name'] ?? 'بدون اسم',
      location: json['location'] ?? 'غير محدد',
      price: json['price'] ?? '0 جنيه',
      time: json['time'] ?? '--:--',
      type: json['type'] ?? 'تحصيل',
    );
  }
}