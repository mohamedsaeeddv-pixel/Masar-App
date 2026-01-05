import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String nameAr;     // من حقل nameAr في الصورة
  final String nameEn;     // من حقل nameEn في الصورة
  final String email;      // من حقل email في الصورة
  final String phone;      // من حقل phone في الصورة
  final String role;       // من حقل role في الصورة
  final String userId;     // من حقل user_Id في الصورة
  final Timestamp createdAt; // من حقل createdAt (Timestamp)

  // حقول إضافية (لو مش موجودة في الـ User document ممكن تسيبها بقيم افتراضية)
  final String workingHours;
  final String completedTasks;

  ProfileModel({
    required this.nameAr,
    required this.nameEn,
    required this.email,
    required this.phone,
    required this.role,
    required this.userId,
    required this.createdAt,
    this.workingHours = "0",
    this.completedTasks = "0",
  });

  // ميثود تحويل البيانات من Firestore (Map) إلى كائن (Object)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'representative',
      userId: json['user_Id'] ?? '',
      // التعامل مع الـ Timestamp الخاص بـ Firebase
      createdAt: json['createdAt'] as Timestamp,
      // الحقول دي لو مش موجودة في الدكيومنت حالياً هتاخد القيمة الافتراضية
      workingHours: json['workingHours']?.toString() ?? '0',
      completedTasks: json['completedTasks']?.toString() ?? '0',
    );
  }

  // ميثود لتحويل الكائن إلى Map لو حبيت تعمل Update للبيانات
  Map<String, dynamic> toJson() {
    return {
      'nameAr': nameAr,
      'nameEn': nameEn,
      'email': email,
      'phone': phone,
      'role': role,
      'user_Id': userId,
      'createdAt': createdAt,
      'workingHours': workingHours,
      'completedTasks': completedTasks,
    };
  }
}