import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';

import '../models/product_model.dart';
abstract class ProductsRepository {
  Stream<Either<Failure, List<ProductModel>>> getAvailableProducts();
}
