import '../entities/product_entity.dart';
import '../models/filter_query.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> fetchProducts({FilterQuery? filter});
  Future<ProductEntity?> fetchProductById(String id);
  Future<ProductEntity?> updateProduct(ProductEntity product);
}
