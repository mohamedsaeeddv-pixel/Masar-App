class TaskTypeModel {
  final String key;
  final String label;

  TaskTypeModel({
    required this.key,
    required this.label,
  });

  factory TaskTypeModel.fromMap(Map<String, dynamic> map) {
    return TaskTypeModel(
      key: map['key'],
      label: map['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'label': label,
    };
  }
}
