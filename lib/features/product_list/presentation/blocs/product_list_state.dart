import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/models/filter_query.dart';

abstract class ProductListState {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

class ProductListRefreshing extends ProductListState {
  final List<ProductEntity> products;

  const ProductListRefreshing({required this.products});
}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final FilterQuery? currentFilter;

  const ProductListSuccess({required this.products, this.currentFilter});
}

class ProductListEmpty extends ProductListState {
  const ProductListEmpty();
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError({required this.message});
}
