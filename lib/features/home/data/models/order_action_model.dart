class OrderActionModel {
  final String orderId;
  final String agentId;
  final String clientId;
  final OrderActionType type;
  final DateTime timestamp;
  final String? notes;
  final String? productName;
  final double? productPrice;
  final int? quantity; // <-- جديد

  OrderActionModel({
    required this.orderId,
    required this.agentId,
    required this.clientId,
    required this.type,
    required this.timestamp,
    this.notes,
    this.productName,
    this.productPrice,
    this.quantity, // <-- جديد
  });

  factory OrderActionModel.completeOrder({
     String? orderId,
    required String agentId,
    required String clientId,
    required bool delivered,
    DateTime? timestamp,
    String? notes,
    String? productName,
    double? productPrice,
    int? quantity, // <-- جديد
  }) {
    return OrderActionModel(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      agentId: agentId,
      clientId: clientId,
      type: delivered ? OrderActionType.delivered : OrderActionType.received,
      timestamp: timestamp ?? DateTime.now(),
      notes: notes,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity, // <-- جديد
    );
  }

  factory OrderActionModel.returnOrder({
     String? orderId,
    required String agentId,
    required String clientId,
    DateTime? timestamp,
    String? notes,
    String? productName,
    double? productPrice,
    int? quantity, // <-- جديد
  }) {
    return OrderActionModel(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      agentId: agentId,
      clientId: clientId,
      type: OrderActionType.returnOrder,
      timestamp: timestamp ?? DateTime.now(),
      notes: notes,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity, // <-- جديد
    );
  }

  factory OrderActionModel.newOrder({
     String? orderId,
    required String agentId,
    required String clientId,
    DateTime? timestamp,
    String? notes,
    String? productName,
    double? productPrice,
    int? quantity, // <-- جديد
  }) {
    return OrderActionModel(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      agentId: agentId,
      clientId: clientId,
      type: OrderActionType.newOrder,
      timestamp: timestamp ?? DateTime.now(),
      notes: notes,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity, // <-- جديد
    );
  }

  factory OrderActionModel.cancelOrder({
     String? orderId,
    required String agentId,
    required String clientId,
    DateTime? timestamp,
    String? notes,
  }) {
    return OrderActionModel(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      agentId: agentId,
      clientId: clientId,
      type: OrderActionType.cancelled,
      timestamp: timestamp ?? DateTime.now(),
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'agentId': agentId,
      'clientId': clientId,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity, // <-- جديد
    };
  }
}


enum OrderActionType {
  received,
  delivered,
  cancelled,
  newOrder,
  returnOrder,
}
