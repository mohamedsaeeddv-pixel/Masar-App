import 'dart:async'; // ضروري للتعامل مع الـ StreamSubscription
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/dashboard_repo.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo repo;
  StreamSubscription? _dashboardSubscription;

  DashboardCubit(this.repo) : super(DashboardInitial());

  void fetchDashboardData() {
    emit(DashboardLoading());

    _dashboardSubscription?.cancel();

    _dashboardSubscription = repo.getDashboardData().listen(
          (data) {
        emit(DashboardLoaded(data));
      },
      onError: (e) {
        emit(DashboardError("حدث خطأ أثناء تحميل البيانات"));
      },
    );
  }

  @override
  Future<void> close() {
    _dashboardSubscription?.cancel();
    return super.close();
  }
}