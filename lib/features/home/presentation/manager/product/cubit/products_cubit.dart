import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/features/home/data/repos/product_repo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository repository;
  StreamSubscription? _subscription;

  ProductsCubit({required this.repository})
      : super(ProductsInitial());

  void getProducts() {
    emit(ProductsLoading());

    _subscription?.cancel();
    _subscription = repository.getAvailableProducts().listen(
      (either) {
        either.fold(
          (failure) => emit(
            ProductsFailure(failure.errorMessage),
          ),
          (products) => emit(
            ProductsSuccess(products),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
