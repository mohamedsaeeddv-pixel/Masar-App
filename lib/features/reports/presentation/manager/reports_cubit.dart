import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/reports_repo.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepo reportsRepo;

  // هنا بنستخدم الـ ReportsInitial اللي سألت عليها
  ReportsCubit(this.reportsRepo) : super(ReportsInitial());

  void fetchReports(String period) {
    emit(ReportsLoading());
    try {
      final data = reportsRepo.getReportsData(period);
      emit(ReportsSuccess(data));
    } catch (e) {
      emit(ReportsError("حدث خطأ في تحميل البيانات"));
    }
  }
}