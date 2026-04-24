import 'package:get_it/get_it.dart';
import '../data/datasources/product_datasource.dart';
import '../data/datasources/product_hive_datasource.dart';
import '../data/repositories/product_list_repository_impl.dart';
import '../domain/repositories/product_list_repository.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';

void initProductListDependencies(GetIt getIt) {
  // Data sources
  getIt.registerSingleton<ProductMockDataSource>(ProductMockDataSource());
  getIt.registerSingleton<ProductHiveDataSource>(ProductHiveDataSource());

  // Repository
  getIt.registerFactory<ProductListRepository>(
    () => ProductListRepositoryImpl(dataSource: getIt<ProductMockDataSource>()),
  );

  // Use cases
  getIt.registerFactory<GetProductsUseCase>(() => GetProductsUseCase(repository: getIt<ProductListRepository>()));
  getIt.registerFactory<GetProductByIdUseCase>(() => GetProductByIdUseCase(repository: getIt<ProductListRepository>()));
}
