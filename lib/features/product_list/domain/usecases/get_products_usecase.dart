import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call({String? query}) => repository.fetchProducts(query: query);
}
