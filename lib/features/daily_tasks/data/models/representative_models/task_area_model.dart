class AreaModel {
  final int id;
  final String name;

  AreaModel({required this.id, required this.name});

  factory AreaModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return AreaModel(id: 0, name: 'غير معروف');

    return AreaModel(
      id: map['id'] ?? 0,
      name: map['name']?.toString() ?? 'غير معروف',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
