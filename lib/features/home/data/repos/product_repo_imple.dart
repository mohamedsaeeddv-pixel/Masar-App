import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/home/data/models/product_model.dart';
import 'package:masar_app/features/home/data/repos/product_repo.dart';


class ProductsRepositoryImpl implements ProductsRepository {
  final FirebaseFirestore firestore;

  ProductsRepositoryImpl({required this.firestore});

  @override
  Stream<Either<Failure, List<ProductModel>>> getAvailableProducts() async* {
    try {
      yield* firestore
          .collection('inventory')
          .where('status', isEqualTo: 'متوفر')
          .snapshots()
          .map(
        (snapshot) {
          final products = snapshot.docs
              .map(ProductModel.fromFirestore)
              .where((product) => product.isAvailable)
              .toList();

          return Right<Failure, List<ProductModel>>(products);
        },
      ).handleError((error) {
        if (error is FirebaseException) {
          return Left<Failure, List<ProductModel>>(
            FirebaseFailure.fromException(error),
          );
        }

        return Left<Failure, List<ProductModel>>(
          const FirebaseFailure(
            errorMessage: 'حدث خطأ غير متوقع',
          ),
        );
      });
    } on FirebaseException catch (e) {
      yield Left(FirebaseFailure.fromException(e));
    } catch (e) {
      yield const Left(
        FirebaseFailure(
          errorMessage: 'حدث خطأ غير متوقع',
        ),
      );
    }
  }
}
