import 'reports_repo.dart';
import '../models/reports_model.dart';

class ReportsRepoImpl implements ReportsRepo {
  @override
  ReportsModel getReportsData(String period) {
    // محاكاة للبيانات بناءً على النوع المختار من الصورة
    if (period == 'يومي') {
      return ReportsModel(
        completedOrders: 15,
        totalOrders: 20,
        salesAmount: 2250,
        totalSalesGoal: 3000,
        distanceKm: 32,
        reportPeriod: 'يومي',
      );
    } else if (period == 'أسبوعي') {
      return ReportsModel(
        completedOrders: 85,
        totalOrders: 100,
        salesAmount: 12750,
        totalSalesGoal: 15000,
        distanceKm: 210,
        reportPeriod: 'أسبوعي',
      );
    } else {
      return ReportsModel(
        completedOrders: 320,
        totalOrders: 400,
        salesAmount: 48000,
        totalSalesGoal: 60000,
        distanceKm: 850,
        reportPeriod: 'شهري',
      );
    }
  }
}