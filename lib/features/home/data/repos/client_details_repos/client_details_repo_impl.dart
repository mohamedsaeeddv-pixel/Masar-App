import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/core/models/client_model.dart';
import 'package:masar_app/features/home/data/repos/client_details_repos/client_details_repo.dart';



class ClientDetailsRepositoryImpl implements ClientDetailsRepository {
  final FirebaseFirestore firestore;

  ClientDetailsRepositoryImpl({required this.firestore});

  CollectionReference get _customerRef =>
      firestore.collection('customers');

  @override
  Future<Either<Failure, ClientModel>> getCustomerById({
    required String clientId,
  }) async {
    try {
      final doc = await _customerRef.doc(clientId).get();

      if (!doc.exists) {
        debugPrint('Client with ID $clientId not found.');
        return left(
       
          const FirebaseFailure(
            errorMessage: 'البيانات غير موجودة',
            code: 'not-found',
          ),
        );
      }

      return right(
        ClientModel.fromMap(
          doc.data() as Map<String, dynamic>,
        ),
      );
    } on FirebaseException catch (e) {
      return left(FirebaseFailure.fromException(e));
    } catch (e) {
      return left(
        const FirebaseFailure(
          errorMessage: 'حدث خطأ غير متوقع',
        ),
      );
    }
  }

  // @override
  // Future<Either<Failure, Unit>> updateCustomer({
  //   required ClientModel customer,
  // }) async {
  //   try {
  //     await _customerRef
  //         .doc(customer.id)
  //         .update(customer.toMap());

  //     return right(unit);
  //   } on FirebaseException catch (e) {
  //     return left(FirebaseFailure.fromException(e));
  //   } catch (e) {
  //     return left(
  //       const FirebaseFailure(
  //         message: 'حدث خطأ غير متوقع',
  //       ),
  //     );
  //   }
  // }
}
