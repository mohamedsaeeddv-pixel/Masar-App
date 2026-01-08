import '../models/reports_model.dart';

abstract class ReportsRepo {
  Stream<ReportsModel> getReportsData(String period);
}