  class AgentModel {
  final String id;
  final String name;
  final String phone;

  AgentModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}
