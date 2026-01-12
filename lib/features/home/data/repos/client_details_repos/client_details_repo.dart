import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/core/models/client_model.dart';


abstract class ClientDetailsRepository {
  Future<Either<Failure, ClientModel>> getCustomerById({
    required String clientId,
  });

  // Future<Either<Failure, Unit>> updateCustomer({
  //   required ClientModel customer,
  // });
}
