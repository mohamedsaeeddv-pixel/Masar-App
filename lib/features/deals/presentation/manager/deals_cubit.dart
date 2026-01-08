import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../data/repos/deals_repo.dart';

abstract class DealsState {}
class DealsInitial extends DealsState {}
class DealsLoading extends DealsState {}
class DealsSuccess extends DealsState {
  final List<DealModel> deals;
  final String activeFilter;
  DealsSuccess(this.deals, {this.activeFilter = "الكل"});
}
class DealsError extends DealsState { final String message; DealsError(this.message); }

class DealsCubit extends Cubit<DealsState> {
  final DealsRepo repo;
  List<DealModel> _allDeals = [];
  StreamSubscription? _dealsSubscription;
  String _currentFilter = "الكل";

  DealsCubit(this.repo) : super(DealsInitial());

  void getDeals() {
    emit(DealsLoading());
    _dealsSubscription?.cancel();

    _dealsSubscription = repo.fetchDeals().listen(
          (deals) {
        _allDeals = deals;
        _applyFilterAndEmit();
      },
      onError: (e) {
        emit(DealsError("خطأ في التحميل: ${e.toString()}"));
      },
    );
  }

  void _applyFilterAndEmit() {
    if (_currentFilter == "الكل") {
      emit(DealsSuccess(_allDeals, activeFilter: "الكل"));
      return;
    }

    // التعديل هنا: بنقارن مباشرة بـ _currentFilter لأن الـ Repo بقا بيبعت "تمت" و "قيد الانتظار"
    final filtered = _allDeals.where((deal) {
      return deal.status == _currentFilter;
    }).toList();

    emit(DealsSuccess(filtered, activeFilter: _currentFilter));
  }

  void filterDeals(String status) {
    _currentFilter = status;
    _applyFilterAndEmit();
  }

  void searchDeals(String query) {
    if (query.isEmpty) {
      _applyFilterAndEmit();
      return;
    }

    final filtered = _allDeals.where((deal) {
      return deal.dealId.contains(query) ||
          deal.customerName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(DealsSuccess(filtered, activeFilter: _currentFilter));
  }

  @override
  Future<void> close() {
    _dealsSubscription?.cancel();
    return super.close();
  }
}