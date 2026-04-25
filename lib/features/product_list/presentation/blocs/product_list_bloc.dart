import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_durations.dart';
import '../../../../shared/domain/models/filter_query.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'debounce_transformer.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  FilterQuery _currentFilter = const FilterQuery();

  ProductListBloc({required this.getProductsUseCase}) : super(const ProductListInitial()) {
    on<FetchProductsEvent>(_onFetch);
    on<RefreshProductsEvent>(_onRefresh);
    on<SearchProductsEvent>(_onSearch, transformer: debounceDroppable(AppDurations.searchDebounce));
    on<ApplyFilterEvent>(_onApplyFilter);
  }

  Future<void> _onFetch(FetchProductsEvent? event, Emitter<ProductListState> emit) async {
    final filter = event?.filter ?? _currentFilter;
    _currentFilter = filter;

    if (event?.refresh == true && state is ProductListSuccess) {
      final current = state as ProductListSuccess;
      emit(ProductListRefreshing(products: current.products));
    } else {
      emit(const ProductListLoading());
    }
    try {
      await Future.delayed(AppDurations.mockDataFetchDelay);
      final products = await getProductsUseCase(filter: filter.hasActiveFilters ? filter : null);
      if (products.isEmpty) {
        emit(const ProductListEmpty());
      } else {
        emit(ProductListSuccess(products: products, currentFilter: filter));
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
}
