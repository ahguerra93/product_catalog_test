import '../../domain/entities/product_entity.dart';
import '../../domain/models/filter_query.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductEntity>> fetchProducts({FilterQuery? filter}) async {
    try {
      return await dataSource.fetchProducts(filter: filter);
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

  @override
  Future<ProductEntity?> updateProduct(ProductEntity product) async {
    try {
      return await dataSource.updateProduct(product);
    } catch (e) {
      rethrow;
    }
  }
}
