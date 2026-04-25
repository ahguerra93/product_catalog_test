import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/models/filter_query.dart';
import '../../../../shared/domain/models/pagination_params.dart';

abstract class ProductListState {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final FilterQuery? currentFilter;
  final PaginationParams pagination;
  final bool isLoadingMore;

  const ProductListSuccess({
    required this.products,
    this.currentFilter,
    required this.pagination,
    this.isLoadingMore = false,
  });
}

class ProductListLoadingMore extends ProductListState {
  final List<ProductEntity> products;
  final FilterQuery? currentFilter;
  final PaginationParams pagination;

  const ProductListLoadingMore({required this.products, this.currentFilter, required this.pagination});
}

class ProductListNoMore extends ProductListState {
  final List<ProductEntity> products;
  final FilterQuery? currentFilter;

  const ProductListNoMore({required this.products, this.currentFilter});
}

class ProductListEmpty extends ProductListState {
  const ProductListEmpty();
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError({required this.message});
}
