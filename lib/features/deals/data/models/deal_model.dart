class DealModel {
  final String dealId;
  final String customerId;
  final String customerName;
  final String amount;
  final String status; // 'تم التوصيل', 'قيد الانتظار', 'فشل'
  final String location;
  final String phone;

  DealModel({
    required this.dealId,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.location,
    required this.phone,
  });
}