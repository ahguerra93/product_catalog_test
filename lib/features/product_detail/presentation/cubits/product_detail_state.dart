import '../../../../shared/domain/entities/product_entity.dart';

abstract class ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  final ProductEntity product;
  ProductDetailSuccess({required this.product});
}

class ProductDetailNotFound extends ProductDetailState {}

class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError({required this.message});
}
