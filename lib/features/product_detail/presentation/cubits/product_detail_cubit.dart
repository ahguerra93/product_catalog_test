import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_durations.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailCubit({required this.getProductByIdUseCase}) : super(ProductDetailLoading());

  Future<void> fetchProduct(String id) async {
    emit(ProductDetailLoading());
    try {
      await Future.delayed(AppDurations.mockDataFetchDelay);
      final product = await getProductByIdUseCase(id);
      if (product == null) {
        emit(ProductDetailNotFound());
      } else {
        emit(ProductDetailSuccess(product: product));
      }
    } catch (e) {
      emit(ProductDetailError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
