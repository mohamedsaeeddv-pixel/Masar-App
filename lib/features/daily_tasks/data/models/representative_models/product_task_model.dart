class ProductTaskModel {
  final String id;
  final String name;
  final int price;
  final int quantity;


  ProductTaskModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    
  });

  factory ProductTaskModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return ProductTaskModel(
        id: '',
        name: 'غير معروف',
        price: 0,
        quantity: 0,
       
      );
    }

    return ProductTaskModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'غير معروف',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 0,
     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      
    };
  }
}
