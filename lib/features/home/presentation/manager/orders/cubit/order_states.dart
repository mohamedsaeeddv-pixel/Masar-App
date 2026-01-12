part of 'order_cubit.dart';

abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderSuccess extends OrderState {
  final String message;
  const OrderSuccess({required this.message});
}

class OrderFailure extends OrderState {
  final String error;
  const OrderFailure({required this.error});
}
