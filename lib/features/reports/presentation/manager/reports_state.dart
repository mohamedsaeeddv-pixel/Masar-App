import '../../data/models/reports_model.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsSuccess extends ReportsState {
  final ReportsModel reportsModel;
  ReportsSuccess({required this.reportsModel});
}

class ReportsFailure extends ReportsState {
  final String errMessage;
  ReportsFailure({required this.errMessage});
}