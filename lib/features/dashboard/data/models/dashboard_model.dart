// features/dashboard/data/models/dashboard_model.dart
class DashboardModel {
  final String userName;
  final int receivedOrders;
  final int deliveredOrders;
  final int weeklyCompletedTasks;
  // أضف أي بيانات أخرى تحتاجها للرسم البياني هنا

  DashboardModel({
    required this.userName,
    required this.receivedOrders,
    required this.deliveredOrders,
    required this.weeklyCompletedTasks,
  });
}