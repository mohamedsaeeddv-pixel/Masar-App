import '../../data/models/reports_model.dart';

abstract class ReportsState {}

// الحالة الابتدائية
class ReportsInitial extends ReportsState {}

// حالة التحميل (لما نغير بين يومي/أسبوعي/شهري)
class ReportsLoading extends ReportsState {}

// حالة النجاح وبنبعت فيها الـ Model اللي فيه الأرقام
class ReportsSuccess extends ReportsState {
  final ReportsModel reportsModel;
  ReportsSuccess(this.reportsModel);
}

// حالة الخطأ
class ReportsError extends ReportsState {
  final String message;
  ReportsError(this.message);
}