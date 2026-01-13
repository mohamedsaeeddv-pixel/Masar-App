import 'package:equatable/equatable.dart';
import '../../data/models/reports_model.dart';

abstract class ReportsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsSuccess extends ReportsState {
  final ReportsModel reportsModel;

  ReportsSuccess({required this.reportsModel});

  @override
  List<Object?> get props => [reportsModel];
}

class ReportsFailure extends ReportsState {
  final String errMessage;
  ReportsFailure({required this.errMessage});

  @override
  List<Object?> get props => [errMessage];
}