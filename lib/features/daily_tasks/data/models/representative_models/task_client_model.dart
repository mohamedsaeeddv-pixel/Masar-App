class ClientTaskModel {
  final String id;
  final String name;
  final String phone;
  final double lat;
  final double lng;

  ClientTaskModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  factory ClientTaskModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return ClientTaskModel(
        id: '',
        name: 'غير معروف',
        phone: '',
        lat: 0,
        lng: 0,
      );
    }

    return ClientTaskModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'غير معروف',
      phone: map['phone']?.toString() ?? '',
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'lat': lat,
      'lng': lng,
    };
  }
}
