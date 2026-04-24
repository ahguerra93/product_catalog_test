import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/product_list_repository.dart';

class GetProductByIdUseCase {
  final ProductListRepository repository;

  GetProductByIdUseCase({required this.repository});

  Future<ProductEntity?> call(String id) => repository.fetchProductById(id);
}
