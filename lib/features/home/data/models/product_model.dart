import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final double price;
  final double? priceAfterDiscount;
  final bool hasDiscount;
  final int quantity;
  final String status;
  final DateTime expireDate;

  ProductModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    this.priceAfterDiscount,
    required this.hasDiscount,
    required this.quantity,
    required this.status,
    required this.expireDate,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: doc.id,
      nameAr: data['nameAr'],
      nameEn: data['nameEn'],
      price: (data['price'] as num).toDouble(),
      priceAfterDiscount: data['priceAfterDiscount'] != null
          ? (data['priceAfterDiscount'] as num).toDouble()
          : null,
      hasDiscount: data['hasDiscount'],
      quantity: data['quantity'],
      status: data['status'],
      expireDate: (data['expireDate'] as Timestamp).toDate(),
    );
  }

  double get finalPrice => hasDiscount ? priceAfterDiscount! : price;

  bool get isAvailable =>
      status == 'متوفر' && quantity > 0 && expireDate.isAfter(DateTime.now());
}
