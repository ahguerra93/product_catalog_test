import '../../../../shared/domain/entities/product_entity.dart';

abstract class ProductListState {}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListRefreshing extends ProductListState {
  final List<ProductEntity> cachedData;
  ProductListRefreshing({required this.cachedData});
}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final List<ProductEntity> filteredProducts;
  final String query;

  ProductListSuccess({required this.products, List<ProductEntity>? filteredProducts, this.query = ''})
    : filteredProducts = filteredProducts ?? products;
}

class ProductListEmpty extends ProductListState {}

class ProductListError extends ProductListState {
  final String message;
  ProductListError({required this.message});
}
