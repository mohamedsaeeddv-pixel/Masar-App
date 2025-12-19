class ClientModel {
  String? id; // معرف العميل في قاعدة البيانات
  final String name;
  final String phone;
  final String latitude;
  final String longitude;
  final String activityType;
  final String classification;
  final String clientType;
  final DateTime createdAt;

  ClientModel({
    this.id,
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.activityType,
    required this.classification,
    required this.clientType,
    required this.createdAt,
  });

  // تحويل الكائن (Object) إلى Map لإرساله لـ Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'activityType': activityType,
      'classification': classification,
      'clientType': clientType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // تحويل البيانات القادمة من Firebase إلى كائن (Object)
  factory ClientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ClientModel(
      id: documentId,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      latitude: map['latitude'] ?? '0',
      longitude: map['longitude'] ?? '0',
      activityType: map['activityType'] ?? '',
      classification: map['classification'] ?? '',
      clientType: map['clientType'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}