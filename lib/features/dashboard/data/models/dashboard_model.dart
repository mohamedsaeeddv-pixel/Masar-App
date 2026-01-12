class DashboardModel {
  final String userName;
  final int receivedOrders;
  final int deliveredOrders;
  final int weeklyCompletedTasks;
  final double deliveredPercent;
  final double returnedPercent;
  final double failedPercent;

  DashboardModel({
    required this.userName,
    required this.receivedOrders,
    required this.deliveredOrders,
    required this.weeklyCompletedTasks,
    required this.deliveredPercent,
    required this.returnedPercent,
    required this.failedPercent,
  });
}