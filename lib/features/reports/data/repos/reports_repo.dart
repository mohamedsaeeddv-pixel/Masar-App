import '../models/reports_model.dart';

class ReportsRepo {
  ReportsModel getReportsData(String period) {
    // محاكاة للبيانات الموجودة في الصورة
    if (period == 'يومي') {
      return ReportsModel(completedOrders: 15, totalOrders: 20, salesAmount: 2250, totalSalesGoal: 3000, distanceKm: 32, reportPeriod: 'يومي');
    }
    return ReportsModel(completedOrders: 85, totalOrders: 100, salesAmount: 12750, totalSalesGoal: 15000, distanceKm: 32, reportPeriod: 'أسبوعي');
  }
}