import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_durations.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/models/filter_query.dart';
import '../../../../shared/domain/models/pagination_params.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'debounce_transformer.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  FilterQuery _currentFilter = const FilterQuery();
  PaginationParams _pagination = PaginationParams.empty();
  List<ProductEntity> _accumulatedProducts = [];

  ProductListBloc({required this.getProductsUseCase}) : super(const ProductListLoading()) {
    on<FetchProductsEvent>(_onFetch);
    on<RefreshProductsEvent>(_onRefresh);
    on<SearchProductsEvent>(_onSearch, transformer: debounceDroppable(AppDurations.searchDebounce));
    on<ApplyFilterEvent>(_onApplyFilter);
    on<LoadMoreProductsEvent>(_onLoadMore);
  }

  Future<void> _onFetch(FetchProductsEvent? event, Emitter<ProductListState> emit) async {
    final filter = event?.filter ?? _currentFilter;
    _currentFilter = filter;

    // Reset pagination for new fetch
    _pagination = PaginationParams.empty();
    _accumulatedProducts = [];

    emit(const ProductListLoading());
    try {
      await Future.delayed(AppDurations.mockDataFetchDelay);
      final products = await getProductsUseCase(
        filter: filter.hasActiveFilters ? filter : null,
        offset: _pagination.offset,
        limit: _pagination.limit,
      );
      if (products.isEmpty) {
        emit(const ProductListEmpty());
      } else {
        _accumulatedProducts = products;
        final hasMore = products.length >= _pagination.limit;
        _pagination = _pagination.updateHasMore(hasMore);
        emit(ProductListSuccess(products: products, currentFilter: filter, pagination: _pagination));
      }
    } catch (e) {
      emit(ProductListError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRefresh(RefreshProductsEvent event, Emitter<ProductListState> emit) async {
    add(FetchProductsEvent(filter: _currentFilter, refresh: true));
  }

  Future<void> _onSearch(SearchProductsEvent event, Emitter<ProductListState> emit) async =>
      add(FetchProductsEvent(filter: _currentFilter.copyWith(query: event.query.isEmpty ? null : event.query)));

  Future<void> _onApplyFilter(ApplyFilterEvent event, Emitter<ProductListState> emit) async {
    add(FetchProductsEvent(filter: event.filter));
  }

  Future<void> _onLoadMore(LoadMoreProductsEvent event, Emitter<ProductListState> emit) async {
    final currentState = state;
    if (currentState is! ProductListSuccess) return;
    if (!_pagination.hasMore) return;

    try {
      // Mark as loading more
      _pagination = _pagination.markLoadingMore();
      emit(
        ProductListLoadingMore(products: _accumulatedProducts, currentFilter: _currentFilter, pagination: _pagination),
      );

      // Fetch next page
      await Future.delayed(AppDurations.mockDataFetchDelay);
      final nextProducts = await getProductsUseCase(
        filter: _currentFilter.hasActiveFilters ? _currentFilter : null,
        offset: _pagination.nextPage().offset,
        limit: _pagination.limit,
      );

      if (nextProducts.isEmpty) {
        // No more products
        _pagination = _pagination.updateHasMore(false);
        emit(ProductListNoMore(products: _accumulatedProducts, currentFilter: _currentFilter));
      } else {
        // Append new products
        _accumulatedProducts.addAll(nextProducts);
        final hasMore = nextProducts.length >= _pagination.limit;
        _pagination = _pagination.nextPage().updateHasMore(hasMore);
        emit(
          ProductListSuccess(
            products: _accumulatedProducts,
            currentFilter: _currentFilter,
            pagination: _pagination,
            isLoadingMore: false,
          ),
        );
      }
    } catch (e) {
      emit(ProductListError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
