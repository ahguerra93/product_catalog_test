import '../../../../shared/domain/entities/product_entity.dart';

abstract class UpdateProductDetailState {
  const UpdateProductDetailState();
}

class UpdateProductDetailLoaded extends UpdateProductDetailState {
  final ProductEntity product;
  final String priceInput;
  final Currency currency;
  final bool isLoading;

  const UpdateProductDetailLoaded({
    required this.product,
    required this.priceInput,
    required this.currency,
    this.isLoading = false,
  });

  bool get hasChanges {
    final originalPrice = product.price.toString();
    return priceInput != originalPrice || currency != product.currency;
  }

  UpdateProductDetailLoaded copyWith({
    ProductEntity? product,
    String? priceInput,
    Currency? currency,
    bool? isLoading,
  }) {
    return UpdateProductDetailLoaded(
      product: product ?? this.product,
      priceInput: priceInput ?? this.priceInput,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UpdateProductDetailSuccess extends UpdateProductDetailState {
  final ProductEntity updatedProduct;

  const UpdateProductDetailSuccess({required this.updatedProduct});
}

class UpdateProductDetailError extends UpdateProductDetailState {
  final String message;

  const UpdateProductDetailError({required this.message});
}
