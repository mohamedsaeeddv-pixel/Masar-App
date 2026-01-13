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
  final int timestamp;

  DealsSuccess(this.deals, {this.activeFilter = "الكل", required this.timestamp});
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
      onError: (e) => emit(DealsError(e.toString())),
    );
  }

  void _applyFilterAndEmit() {
    final filtered = _currentFilter == "الكل"
        ? _allDeals
        : _allDeals.where((deal) => deal.status == _currentFilter).toList();

    emit(DealsSuccess(
      filtered,
      activeFilter: _currentFilter,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void filterDeals(String status) {
    _currentFilter = status;
    _applyFilterAndEmit();
  }

  void searchDeals(String query) {
    if (query.isEmpty) { _applyFilterAndEmit(); return; }
    final filtered = _allDeals.where((deal) =>
    deal.customerName.toLowerCase().contains(query.toLowerCase()) ||
        deal.taskTitle.toLowerCase().contains(query.toLowerCase())).toList();

    emit(DealsSuccess(filtered, activeFilter: _currentFilter, timestamp: DateTime.now().millisecondsSinceEpoch));
  }

  @override
  Future<void> close() {
    _dealsSubscription?.cancel();
    return super.close();
  }
}