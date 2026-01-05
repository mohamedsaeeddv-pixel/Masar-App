class TaskClientModel {
  final String clientId; // reference to ClientModel.id
  final String name;
  final String phone;
  final double lat;
  final double lng;

  TaskClientModel({
    required this.clientId,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  factory TaskClientModel.fromMap(Map<String, dynamic> map) {
    return TaskClientModel(
      clientId: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': clientId,
      'name': name,
      'phone': phone,
      'lat': lat,
      'lng': lng,
    };
  }
}
