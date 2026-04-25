import 'package:hive/hive.dart';
import '../../../common/app_durations.dart';
import '../../data/models/product_hive_model.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/enums/simulation_mode.dart';
import '../../domain/enums/sort_type.dart';
import '../../domain/models/filter_query.dart';
import '../../../config/logger_config.dart';
import '../../../di/di.dart';
import 'product_datasource.dart';

class ProductHiveDataSource implements ProductDataSource {
  static const String _boxName = 'products';
  SimulationMode simulationMode;

  ProductHiveDataSource({this.simulationMode = SimulationMode.success});

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

  Future<List<ProductEntity>> getCachedProducts({FilterQuery? filter, int offset = 0, int limit = 10}) async {
    _checkSimulationMode();
    await Future.delayed(AppDurations.mockFastFetchDelay);

    final box = await _openBox();
    var results = box.values.toList();
    getIt<LoggerService>().logCacheHit('products_cache', hit: results.isNotEmpty);

    if (filter == null || !filter.hasActiveFilters) {
      final paginated = results.skip(offset).take(limit).toList();
      final entities = paginated.map((m) => m.toEntity()).toList();
      getIt<LoggerService>().logDataAsJson('ProductHiveDataSource.getCachedProducts', entities);
      return entities;
    }

    // Filter by query (name or SKU)
    if (filter.query != null && filter.query!.isNotEmpty) {
      final q = filter.query!.toLowerCase();
      results = results.where((m) {
        return m.name.toLowerCase().contains(q) || m.sku.toLowerCase().contains(q);
      }).toList();
    }

    // Filter by currency
    if (filter.currency != null) {
      results = results.where((m) => m.currency == filter.currency).toList();
    }

    // Filter by price range
    if (filter.priceRange != null && filter.priceRange!.isValid) {
      final minPrice = filter.priceRange!.minPrice ?? 0;
      final maxPrice = filter.priceRange!.maxPrice ?? double.infinity;
      results = results.where((m) => m.price >= minPrice && m.price <= maxPrice).toList();
    }

    // Filter by stock
    if (filter.inStockOnly) {
      results = results.where((m) => m.stock > 0).toList();
    }

    // Sort by price
    if (filter.sorting != null) {
      results.sort((a, b) {
        final comparison = switch (filter.sorting!.sortType) {
          SortType.price => a.price.compareTo(b.price),
          SortType.name => a.name.compareTo(b.name),
          SortType.sku => a.sku.compareTo(b.sku),
        };
        return filter.sorting!.orderBy.name == 'asc' ? comparison : -comparison;
      });
    }

    // Apply pagination after filtering
    final paginated = results.skip(offset).take(limit).toList();
    final entities = paginated.map((m) => m.toEntity()).toList();
    getIt<LoggerService>().logDataAsJson('ProductHiveDataSource.getCachedProducts', entities);
    return entities;
  }

  Future<ProductEntity?> getCachedProductById(String id) async {
    _checkSimulationMode();
    await Future.delayed(AppDurations.mockDetailFetchDelay);

    final box = await _openBox();
    final cached = box.get(id);
    getIt<LoggerService>().logCacheHit('product_$id', hit: cached != null);

    if (cached != null) {
      final entity = cached.toEntity();
      getIt<LoggerService>().logDataAsJson('ProductHiveDataSource.getCachedProductById', [entity]);
      return entity;
    }
    return null;
  }

  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<List<ProductEntity>> fetchProducts({FilterQuery? filter, int offset = 0, int limit = 10}) =>
      getCachedProducts(filter: filter, offset: offset, limit: limit);

  @override
  Future<ProductEntity?> fetchProductById(String id) => getCachedProductById(id);

  @override
  Future<ProductEntity?> updateProduct(ProductEntity product) async {
    _checkSimulationMode();
    await Future.delayed(AppDurations.mockDataFetchDelay);

    final box = await _openBox();
    final model = ProductHiveModel.fromEntity(product);
    await box.put(product.id, model);
    getIt<LoggerService>().logDataAsJson('ProductHiveDataSource.updateProduct', [product]);
    return product;
  }

  void _checkSimulationMode() {
    if (simulationMode == SimulationMode.error) {
      throw Exception('Failed to load from cache. Please try again.');
    }
  }
}
