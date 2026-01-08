import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/reports_repo.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepo reportsRepo;

  StreamSubscription? _reportsSubscription;

  ReportsCubit(this.reportsRepo) : super(ReportsInitial());

  void fetchReports(String period) {
    emit(ReportsLoading());

    _reportsSubscription?.cancel();

    _reportsSubscription = reportsRepo.getReportsData(period).listen(
          (reportsModel) {
        emit(ReportsSuccess(reportsModel: reportsModel));
      },
      onError: (error) {
        emit(ReportsFailure(errMessage: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _reportsSubscription?.cancel();
    return super.close();
  }
}