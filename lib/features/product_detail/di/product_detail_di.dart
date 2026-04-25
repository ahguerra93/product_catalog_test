import 'package:get_it/get_it.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import '../presentation/cubits/product_detail_cubit.dart';

void initProductDetailDependencies(GetIt getIt) {
  // Use cases
  getIt.registerFactory<GetProductByIdUseCase>(() => GetProductByIdUseCase(repository: getIt()));

  // Cubit
  getIt.registerFactory<ProductDetailCubit>(
    () => ProductDetailCubit(getProductByIdUseCase: getIt<GetProductByIdUseCase>()),
  );
}
