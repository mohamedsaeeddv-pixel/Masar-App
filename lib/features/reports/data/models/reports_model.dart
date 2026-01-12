class ReportsModel {
  final int completedOrders;
  final int totalOrdersGoal; // الهدف (مثلاً 400)
  final double salesAmount;
  final double totalSalesGoal; // الهدف المالي (مثلاً 60000)
  final double distanceKm;
  final String reportPeriod;

  ReportsModel({
    required this.completedOrders,
    required this.totalOrdersGoal,
    required this.salesAmount,
    required this.totalSalesGoal,
    required this.distanceKm,
    required this.reportPeriod,
  });

  double get ordersPercentage => (totalOrdersGoal > 0) ? (completedOrders / totalOrdersGoal) * 100 : 0;

  double get salesPercentage => (totalSalesGoal > 0) ? (salesAmount / totalSalesGoal) * 100 : 0;

  int get remainingOrders => totalOrdersGoal - completedOrders;
}