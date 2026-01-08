import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final OrderArea? area;
  final DateTime? createdAt;
  final OrderCustomer? customer;
  final List<OrderProduct> products;
  final String? representativeId;
  final String? status;
  final TaskType? taskType;
  final double? totalPrice;

  OrderModel({
    this.area,
    this.createdAt,
    this.customer,
    this.products = const [],
    this.representativeId,
    this.status,
    this.taskType,
    this.totalPrice,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      // معالجة الـ Map الخاصة بالمنطقة
      area: map['area'] != null ? OrderArea.fromMap(map['area']) : null,

      // تحويل Timestamp الفايربيز لـ DateTime
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,

      // معالجة الـ Map الخاصة بالعميل
      customer: map['customer'] != null ? OrderCustomer.fromMap(map['customer']) : null,

      // معالجة الـ Array الخاصة بالمنتجات (تحويل كل عنصر في الـ Array لـ Model)
      products: (map['products'] as List?)
          ?.map((p) => OrderProduct.fromMap(p))
          .toList() ?? [],

      representativeId: map['representativeId'],
      status: map['status'],
      taskType: map['taskType'] != null ? TaskType.fromMap(map['taskType']) : null,
      totalPrice: (map['totalPrice'] as num?)?.toDouble(),
    );
  }
}

// الـ Sub-Models (الموديلات الفرعية اللي متجمعة جوه الموديل الأساسي)

class OrderArea {
  final int? id;
  final String? name;

  OrderArea({this.id, this.name});

  factory OrderArea.fromMap(Map<String, dynamic> map) {
    return OrderArea(id: map['id'], name: map['name']);
  }
}

class OrderCustomer {
  final String? id;
  final String? name;
  final String? phone;
  final double? lat;
  final double? lng;

  OrderCustomer({this.id, this.name, this.phone, this.lat, this.lng});

  factory OrderCustomer.fromMap(Map<String, dynamic> map) {
    return OrderCustomer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
    );
  }
}

class OrderProduct {
  final String? id;
  final String? name;
  final double? price;
  final int? quantity;
  final String? status;

  OrderProduct({this.id, this.name, this.price, this.quantity, this.status});

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num?)?.toDouble(),
      quantity: map['quantity'],
      status: map['status'],
    );
  }
}

class TaskType {
  final String? key;
  final String? label;

  TaskType({this.key, this.label});

  factory TaskType.fromMap(Map<String, dynamic> map) {
    return TaskType(key: map['key'], label: map['label']);
  }
}