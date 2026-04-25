import '../../../../features/product_list/data/datasources/product_hive_datasource.dart';
import '../../../../features/startup/data/datasources/local_product_datasource.dart';
import '../../domain/repositories/startup_repository.dart';

class StartupRepositoryImpl implements StartupRepository {
  final ProductHiveDataSource productHiveDataSource;
  final LocalProductDataSource localProductDataSource;

  StartupRepositoryImpl({required this.productHiveDataSource, required this.localProductDataSource});

  @override
  Future<void> initializeData() async {
    final cached = await productHiveDataSource.getCachedProducts();
    if (cached.isNotEmpty) return;

    final products = await localProductDataSource.loadProducts();
    await productHiveDataSource.cacheProducts(products);
  }
}
