import 'package:get_it/get_it.dart';
import '../data/datasources/product_datasource.dart';
import '../data/datasources/product_hive_datasource.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';

void initSharedDependencies(GetIt getIt) {
  // Data sources (if not already registered by another feature)
  if (!getIt.isRegistered<ProductMockDataSource>()) {
    getIt.registerSingleton<ProductMockDataSource>(ProductMockDataSource());
  }
  if (!getIt.isRegistered<ProductHiveDataSource>()) {
    getIt.registerLazySingleton<ProductHiveDataSource>(() => ProductHiveDataSource());
  }

  // Repository
  getIt.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(dataSource: getIt<ProductHiveDataSource>()),
  );
}
