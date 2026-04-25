import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_durations.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'update_product_detail_state.dart';

class UpdateProductDetailCubit extends Cubit<UpdateProductDetailState> {
  final UpdateProductUseCase updateProductUseCase;
  final ProductEntity initialProduct;

  UpdateProductDetailCubit({required this.updateProductUseCase, required this.initialProduct})
    : super(
        UpdateProductDetailLoaded(
          product: initialProduct,
          priceInput: initialProduct.price.toString(),
          currency: initialProduct.currency,
        ),
      );

  void updatePrice(String price) {
    final current = state as UpdateProductDetailLoaded;
    emit(current.copyWith(priceInput: price));
  }

  void updateCurrency(Currency currency) {
    final current = state as UpdateProductDetailLoaded;
    emit(current.copyWith(currency: currency));
  }

  Future<void> submitUpdate() async {
    final current = state as UpdateProductDetailLoaded;

    // Validate price
    final priceValue = double.tryParse(current.priceInput);
    if (priceValue == null || priceValue <= 0) {
      return;
    }

    emit(current.copyWith(isLoading: true));

    try {
      await Future.delayed(AppDurations.mockDataFetchDelay);

      final updatedProduct = current.product.copyWith(price: priceValue, currency: current.currency);

      final result = await updateProductUseCase(updatedProduct);
      if (result != null) {
        emit(UpdateProductDetailSuccess(updatedProduct: result));
      } else {
        emit(const UpdateProductDetailError(message: 'Failed to update product'));
      }
    } catch (e) {
      emit(UpdateProductDetailError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
