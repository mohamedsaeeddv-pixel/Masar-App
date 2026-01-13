class ReportsModel {
  final String userName; // السطر ده زاد عشان يشيل الاسم اللي جاي من الـ users collection
  final int completedOrders;
  final int totalOrdersGoal; // الهدف (مثلاً 400)
  final double salesAmount;
  final double totalSalesGoal; // الهدف المالي (مثلاً 60000)
  final double distanceKm;
  final String reportPeriod;

  ReportsModel({
    required this.userName, // أضفناه هنا عشان الـ UI ميزعلش
    required this.completedOrders,
    required this.totalOrdersGoal,
    required this.salesAmount,
    required this.totalSalesGoal,
    required this.distanceKm,
    required this.reportPeriod,
  });

  // الـ Getters بتاعتك زي ما هي ملمستهاش
  double get ordersPercentage => (totalOrdersGoal > 0) ? (completedOrders / totalOrdersGoal) * 100 : 0;

  double get salesPercentage => (totalSalesGoal > 0) ? (salesAmount / totalSalesGoal) * 100 : 0;

  int get remainingOrders => totalOrdersGoal - completedOrders;
}