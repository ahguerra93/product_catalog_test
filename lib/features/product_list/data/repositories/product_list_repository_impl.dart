import '../../../../shared/domain/entities/product_entity.dart';
import '../../domain/repositories/product_list_repository.dart';
import '../datasources/product_datasource.dart';

class ProductListRepositoryImpl implements ProductListRepository {
  final ProductDataSource dataSource;

  ProductListRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductEntity>> fetchProducts() async {
    try {
      return await dataSource.fetchProducts();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductEntity?> fetchProductById(String id) async {
    try {
      return await dataSource.fetchProductById(id);
    } catch (e) {
      rethrow;
    }
  }
}
