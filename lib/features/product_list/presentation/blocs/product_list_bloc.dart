import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_durations.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'debounce_transformer.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  String _currentQuery = '';

  ProductListBloc({required this.getProductsUseCase}) : super(const ProductListInitial()) {
    on<FetchProductsEvent>(_onFetch);
    on<RefreshProductsEvent>(_onRefresh);
    on<SearchProductsEvent>(_onSearch, transformer: debounceDroppable(AppDurations.searchDebounce));
  }

  Future<void> _onFetch(FetchProductsEvent? event, Emitter<ProductListState> emit) async {
    _currentQuery = event?.query ?? '';

    if (event?.refresh == true && state is ProductListSuccess) {
      final current = state as ProductListSuccess;
      emit(ProductListRefreshing(products: current.products));
    } else {
      emit(const ProductListLoading());
    }
    try {
      await Future.delayed(AppDurations.mockDataFetchDelay);
      final products = await getProductsUseCase(query: _currentQuery.isEmpty ? null : _currentQuery);
      if (products.isEmpty) {
        emit(const ProductListEmpty());
      } else {
        emit(ProductListSuccess(products: products));
      }
    } catch (e) {
      emit(ProductListError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRefresh(RefreshProductsEvent event, Emitter<ProductListState> emit) async {
    add(FetchProductsEvent(query: _currentQuery, refresh: true));
  }

  Future<void> _onSearch(SearchProductsEvent event, Emitter<ProductListState> emit) async =>
      add(FetchProductsEvent(query: event.query));
}
