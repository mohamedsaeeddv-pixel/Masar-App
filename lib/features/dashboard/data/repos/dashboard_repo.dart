// features/dashboard/data/repos/dashboard_repo.dart
import '../models/dashboard_model.dart';

class DashboardRepo {
  Future<DashboardModel> getDashboardData() async {
    // محاكاة لجلب البيانات من API أو Firebase
    await Future.delayed(const Duration(seconds: 1));
    return DashboardModel(
      userName: "محمد",
      receivedOrders: 12,
      deliveredOrders: 9,
      weeklyCompletedTasks: 55,
    );
  }
}