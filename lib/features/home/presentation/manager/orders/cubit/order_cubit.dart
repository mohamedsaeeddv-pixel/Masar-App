import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/features/home/data/models/order_action_model.dart';
import 'package:masar_app/features/home/data/repos/order_repo.dart';

part 'order_states.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderCubit({required this.repository}) : super(OrderInitial());

  Future<void> sendAction(OrderActionModel action) async {
    emit(OrderLoading());

    final result = await repository.sendOrderAction(action);

    result.fold(
      (failure) => emit(OrderFailure(error: failure.errorMessage)),
      (_) {
        // الرسالة تختلف حسب نوع الطلب
        final msg = switch (action.type) {
          OrderActionType.newOrder => 'تم تأكيد الطلب بنجاح',
          OrderActionType.returnOrder => 'تم تأكيد طلب الاسترجاع بنجاح',
          OrderActionType.delivered => 'تم تأكيد تسليم الطلب بنجاح',
          OrderActionType.cancelled => 'تم إلغاء الطلب بنجاح',
          OrderActionType.received => 'تم تأكيد الاسترجاع  بنجاح',
        };

        emit(OrderSuccess(message: msg));
      },
    );
  }
}
