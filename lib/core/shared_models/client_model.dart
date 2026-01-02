import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String id; // document id
  final String name;
  final String nameAr;
  final GeoPoint address;
  final String phone;
  final String activity;
  final String classification;
  final String type;
  final int visitsCount;
  final num totalSpent;
  final Timestamp? createdAt;

  ClientModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.address,
    required this.phone,
    required this.activity,
    required this.classification,
    required this.type,
    this.visitsCount = 0,
    this.totalSpent = 0,
    this.createdAt,
  });

  /// READ from Firestore
  factory ClientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ClientModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameAr: data['nameAr'] ?? '',
      address: data['address'],
      phone: data['phone'] ?? '',
      activity: data['activity'] ?? '',
      classification: data['classification'] ?? '',
      type: data['type'] ?? '',
      visitsCount: data['visitsCount'] ?? 0,
      totalSpent: data['totalSpent'] ?? 0,
      createdAt: data['createdAt'],
    );
  }

  /// WRITE to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr': nameAr,
      'address': address,
      'phone': phone,
      'activity': activity,
      'classification': classification,
      'type': type,
      'visitsCount': visitsCount,
      'totalSpent': totalSpent,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// UPDATE helper
  ClientModel copyWith({
    int? visitsCount,
    num? totalSpent,
  }) {
    return ClientModel(
      id: id,
      name: name,
      nameAr: nameAr,
      address: address,
      phone: phone,
      activity: activity,
      classification: classification,
      type: type,
      visitsCount: visitsCount ?? this.visitsCount,
      totalSpent: totalSpent ?? this.totalSpent,
      createdAt: createdAt,
    );
  }
}
