import 'package:get_it/get_it.dart';
import '../../../shared/domain/repositories/product_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../presentation/blocs/product_list_bloc.dart';

void initProductListDependencies(GetIt getIt) {
  // Use cases
  getIt.registerFactory<GetProductsUseCase>(() => GetProductsUseCase(repository: getIt<ProductRepository>()));

  // BLoC
  getIt.registerFactory<ProductListBloc>(() => ProductListBloc(getProductsUseCase: getIt<GetProductsUseCase>()));
}
