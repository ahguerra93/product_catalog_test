import '../../../../shared/domain/entities/product_entity.dart';

abstract class ProductListRepository {
  Future<List<ProductEntity>> fetchProducts();
  Future<ProductEntity?> fetchProductById(String id);
}
