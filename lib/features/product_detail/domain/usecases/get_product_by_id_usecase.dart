import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase({required this.repository});

  Future<ProductEntity?> call(String id) => repository.fetchProductById(id);
}
