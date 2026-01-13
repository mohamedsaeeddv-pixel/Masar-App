import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/home/data/repos/order_repo.dart';

part 'order_states.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderCubit({required this.repository}) : super(const OrderInitial());

  Future<void> sendAction(TaskModel task, TaskStatus newStatus) async {
    emit(const OrderLoading());

    final result = await repository.updateOrderStatus(task, newStatus);

    result.fold(
      (failure) => emit(OrderFailure(error: failure.errorMessage)),
      (_) => emit(OrderSuccess(message: _successMessage(newStatus))),
    );
  }

Future<void> addNewOrder(TaskModel task) async {
  emit(const OrderLoading());

  final result = await repository.addNewOrder(task);

  result.fold(
    (failure) => emit(OrderFailure(error: failure.errorMessage)),
    (_) => emit(const OrderSuccess(message: 'تم إنشاء الطلب بنجاح')),
  );
}


  String _successMessage(TaskStatus status) {
    switch (status) {
      case TaskStatus.assigned:
        return 'تم إضافة الطلب بنجاح';
      case TaskStatus.newOrder:
        return 'تم إضافة الطلب بنجاح';
      case TaskStatus.failed:
        return 'تم إلغاء الطلب بنجاح';
      case TaskStatus.completed:
        return 'تم تأكيد استلام الطلب بنجاح';
    }
  }
}
