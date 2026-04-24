import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final GetProductsUseCase getProductsUseCase;

  ProductListCubit({required this.getProductsUseCase}) : super(ProductListInitial());

  Future<void> fetchProducts() async {
    emit(ProductListLoading());
    try {
      final products = await getProductsUseCase();
      if (products.isEmpty) {
        emit(ProductListEmpty());
      } else {
        emit(ProductListSuccess(products: products));
      }
    } catch (e) {
      emit(ProductListError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current is ProductListSuccess) {
      emit(ProductListRefreshing(cachedData: current.products));
    } else {
      emit(ProductListLoading());
    }
    try {
      final products = await getProductsUseCase();
      if (products.isEmpty) {
        emit(ProductListEmpty());
      } else {
        emit(ProductListSuccess(products: products));
      }
    } catch (e) {
      emit(ProductListError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void search(String query) {
    final current = state;
    if (current is ProductListSuccess) {
      if (query.isEmpty) {
        emit(ProductListSuccess(products: current.products, query: query));
        return;
      }
      final filtered = current.products.where((p) {
        final q = query.toLowerCase();
        return p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q);
      }).toList();
      emit(ProductListSuccess(products: current.products, filteredProducts: filtered, query: query));
    }
  }
}
