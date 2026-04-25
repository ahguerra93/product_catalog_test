import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductEntity>> fetchProducts({String? query}) async {
    try {
      return await dataSource.fetchProducts(query: query);
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
