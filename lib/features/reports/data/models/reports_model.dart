class ReportsModel {
  final int completedOrders, totalOrders;
  final double salesAmount, totalSalesGoal, distanceKm;
  final String reportPeriod; // يومي، أسبوعي، شهري

  ReportsModel({
    required this.completedOrders,
    required this.totalOrders,
    required this.salesAmount,
    required this.totalSalesGoal,
    required this.distanceKm,
    required this.reportPeriod,
  });
}