import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/home/data/models/order_action_model.dart';

abstract class OrderRepository {
  Future<Either<Failure, Unit>> sendOrderAction(OrderActionModel actionModel);
}
