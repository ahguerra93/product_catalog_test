import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> fetchProducts({String? query});
  Future<ProductEntity?> fetchProductById(String id);
}
