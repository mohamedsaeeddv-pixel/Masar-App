import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String activity;
  final String activityType;
  final String area;
  final String classification;
  final String lastVisit;
  final String name;   // الاسم بالإنجليزي
  final String nameAr; // الاسم بالعربي
  final String phone;
  final int totalSpent;
  final String type;
  final int visitsCount;
  final GeoPoint? address;

  ClientModel({
    required this.activity,
    required this.activityType,
    required this.area,
    required this.classification,
    required this.lastVisit,
    required this.name,
    required this.nameAr,
    required this.phone,
    required this.totalSpent,
    required this.type,
    required this.visitsCount,
    this.address,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      activity: map['activity'] ?? '',
      activityType: map['activityType'] ?? '',
      area: map['area'] ?? '',
      classification: map['classification'] ?? '',
      lastVisit: map['lastVisit'] ?? '',
      name: map['name'] ?? '',   // English Name
      nameAr: map['nameAr'] ?? '', // Arabic Name
      phone: map['phone'] ?? '',
      totalSpent: (map['totalSpent'] as num? ?? 0).toInt(),
      type: map['type'] ?? '',
      visitsCount: (map['visitsCount'] as num? ?? 0).toInt(),
      address: map['address'] as GeoPoint?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activity': activity,
      'activityType': activityType,
      'area': area,
      'classification': classification,
      'lastVisit': lastVisit,
      'name': name,
      'nameAr': nameAr,
      'phone': phone,
      'totalSpent': totalSpent,
      'type': type,
      'visitsCount': visitsCount,
      if (address != null) 'address': address,
    };
  }
}