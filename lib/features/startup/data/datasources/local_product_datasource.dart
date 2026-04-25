import '../../../../shared/domain/entities/product_entity.dart';

abstract class LocalProductDataSource {
  Future<List<ProductEntity>> loadProducts();
}
