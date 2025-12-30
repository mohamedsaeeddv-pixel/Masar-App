import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../data/repos/deals_repo.dart';

abstract class DealsState {}
class DealsInitial extends DealsState {} // إضافة حالة مبدئية
class DealsLoading extends DealsState {}
class DealsSuccess extends DealsState {
  final List<DealModel> deals;
  final String activeFilter;
  DealsSuccess(this.deals, {this.activeFilter = "الكل"});
}
class DealsError extends DealsState { final String message; DealsError(this.message); }

class DealsCubit extends Cubit<DealsState> {
  final DealsRepo repo;
  List<DealModel> allDeals = [];

  DealsCubit(this.repo) : super(DealsInitial());

  void getDeals() async {
    emit(DealsLoading());
    try {
      allDeals = await repo.fetchDeals();
      emit(DealsSuccess(allDeals));
    } catch (e) {
      emit(DealsError("خطأ في التحميل: ${e.toString()}"));
    }
  }

  void filterDeals(String status) {
    // 1. لو الحالة "الكل" رجع القائمة كاملة
    if (status == "الكل") {
      emit(DealsSuccess(allDeals, activeFilter: "الكل"));
      return;
    }

    // 2. عمل Mapping (ترجمة) للكلمة لو جاية من الـ UI باسم مختلف
    String targetStatus = status;
    if (status == "تمت") {
      targetStatus = "تم التوصيل";
    }

    // 3. الفلترة الفعلية
    final filtered = allDeals.where((deal) {
      return deal.status == targetStatus;
    }).toList();

    emit(DealsSuccess(filtered, activeFilter: status));
  }

  void searchDeals(String query) {
    if (query.isEmpty) {
      emit(DealsSuccess(allDeals));
      return;
    }

    final filtered = allDeals.where((deal) {
      return deal.dealId.contains(query) ||
          deal.customerName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(DealsSuccess(filtered));
  }
}