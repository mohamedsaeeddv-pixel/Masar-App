class DealModel {
  final String dealId;
  final String customerId;
  final String customerName;
  final String amount;
  final String status;
  final String location;
  final String phone;
  final String taskTitle; // الحقل الجديد اللي هنعرضه كعنوان (استرجاع/استلام)

  DealModel({
    required this.dealId,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.location,
    required this.phone,
    required this.taskTitle, // إضافة للـ Constructor
  });
}