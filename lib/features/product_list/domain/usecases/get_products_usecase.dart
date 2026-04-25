import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/models/filter_query.dart';
import '../../../../shared/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call({FilterQuery? filter}) => repository.fetchProducts(filter: filter);
}
