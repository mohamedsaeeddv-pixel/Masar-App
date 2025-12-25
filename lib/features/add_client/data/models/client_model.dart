import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String name;
  final String nameAr;
  final GeoPoint address; // لتخزين الموقع كـ GeoPoint كما في الصورة
  final String phone;
  final String activity;
  final String classification;
  final String type;
  final int visitsCount;
  final int totalSpent;

  ClientModel({
    required this.name,
    required this.nameAr,
    required this.address,
    required this.phone,
    required this.activity,
    required this.classification,
    required this.type,
    this.visitsCount = 0,
    this.totalSpent = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAr': nameAr,
      'address': address, // Firestore بيفهم الـ GeoPoint مباشرة
      'phone': phone,
      'activity': activity,
      'classification': classification,
      'type': type,
      'visitsCount': visitsCount,
      'totalSpent': totalSpent,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}