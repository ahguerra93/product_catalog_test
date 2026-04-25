import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase({required this.repository});

  Future<ProductEntity?> call(ProductEntity product) => repository.updateProduct(product);
}
