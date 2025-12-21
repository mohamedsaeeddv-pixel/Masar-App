import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String content;
  final String senderId;
  final DateTime timestamp;

  ChatModel({
    required this.content,
    required this.senderId,
    required this.timestamp,
  });

  // لتحويل المودل لـ Map قبل الإرسال
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // لتحويل البيانات من Firestore لمودل
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      content: map['content'] ?? '',
      senderId: map['senderId'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(), // fallback مؤقت لحد ما السيرفر يرجع القيمة
    );
  }
}
