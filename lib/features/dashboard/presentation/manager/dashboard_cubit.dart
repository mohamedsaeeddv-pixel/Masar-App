// features/dashboard/presentation/manager/dashboard_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/dashboard_repo.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo repo;

  DashboardCubit(this.repo) : super(DashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(DashboardLoading());
    try {
      final data = await repo.getDashboardData();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError("حدث خطأ أثناء تحميل البيانات"));
    }
  }
}