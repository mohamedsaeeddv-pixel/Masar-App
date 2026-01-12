import 'package:cloud_firestore/cloud_firestore.dart';

class OrderActionModel {
  final String id;           // Firestore doc id
  final String orderId;      // Task / Order id
  final String agentId;      // Representative id
  final String clientId;     // Customer id
  final OrderActionType type;
  final DateTime timestamp;

  // Optional (per action)
  final String? notes;
  final String? productName;
  final double? productPrice;
  final int? quantity;

  OrderActionModel({
    required this.id,
    required this.orderId,
    required this.agentId,
    required this.clientId,
    required this.type,
    required this.timestamp,
    this.notes,
    this.productName,
    this.productPrice,
    this.quantity,
  });

  /// 🔹 Factory موحّدة لكل الحالات
  factory OrderActionModel.create({
    required String orderId,
    required String agentId,
    required String clientId,
    required OrderActionType type,
    String? notes,
    String? productName,
    double? productPrice,
    int? quantity,
    DateTime? timestamp,
  }) {
    return OrderActionModel(
      id: '',
      orderId: orderId,
      agentId: agentId,
      clientId: clientId,
      type: type,
      timestamp: timestamp ?? DateTime.now(),
      notes: notes,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity,
    );
  }

  /// 🔹 Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'agentId': agentId,
      'clientId': clientId,
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'notes': notes,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
    };
  }

  factory OrderActionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return OrderActionModel(
      id: doc.id,
      orderId: data['orderId'],
      agentId: data['agentId'],
      clientId: data['clientId'],
      type: OrderActionTypeX.fromString(data['type']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      notes: data['notes'],
      productName: data['productName'],
      productPrice: data['productPrice'] != null
          ? (data['productPrice'] as num).toDouble()
          : null,
      quantity: data['quantity'],
    );
  }
}
enum OrderActionType {
  received,     // استلام
  delivered,    // تسليم
  cancelled,    // إلغاء
  newOrder,     // طلب جديد
  returnOrder,  // استرجاع
}

extension OrderActionTypeX on OrderActionType {
  static OrderActionType fromString(String value) {
    return OrderActionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderActionType.received,
    );
  }
}
