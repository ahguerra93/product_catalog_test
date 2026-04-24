import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/product_list_repository.dart';

class GetProductsUseCase {
  final ProductListRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call() => repository.fetchProducts();
}
