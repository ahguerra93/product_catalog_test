import 'package:hive/hive.dart';
import '../../../../shared/data/models/product_hive_model.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import 'product_datasource.dart';

class ProductHiveDataSource implements ProductDataSource {
  static const String _boxName = 'products';

  Future<Box<ProductHiveModel>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<ProductHiveModel>(_boxName);
    }
    return Hive.box<ProductHiveModel>(_boxName);
  }

  Future<void> cacheProducts(List<ProductEntity> products) async {
    final box = await _openBox();
    final models = products.map((p) => ProductHiveModel.fromEntity(p)).toList();
    final map = {for (final m in models) m.id: m};
    await box.putAll(map);
  }

  Future<List<ProductEntity>> getCachedProducts() async {
    final box = await _openBox();
    return box.values.map((m) => m.toEntity()).toList();
  }

  Future<ProductEntity?> getCachedProductById(String id) async {
    final box = await _openBox();
    return box.get(id)?.toEntity();
  }

  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<List<ProductEntity>> fetchProducts() => getCachedProducts();

  @override
  Future<ProductEntity?> fetchProductById(String id) => getCachedProductById(id);
}
