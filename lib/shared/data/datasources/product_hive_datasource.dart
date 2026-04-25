import 'package:hive/hive.dart';
import '../../../common/app_durations.dart';
import '../../data/models/product_hive_model.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/enums/simulation_mode.dart';
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

  Future<List<ProductEntity>> getCachedProducts({String? query}) async {
    _checkSimulationMode();
    await Future.delayed(AppDurations.mockFastFetchDelay);

    final box = await _openBox();
    var results = box.values.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where((m) {
        return m.name.toLowerCase().contains(q) || m.sku.toLowerCase().contains(q);
      }).toList();
    }

    return results.map((m) => m.toEntity()).toList();
  }

  Future<ProductEntity?> getCachedProductById(String id) async {
    _checkSimulationMode();
    await Future.delayed(AppDurations.mockDetailFetchDelay);

    final box = await _openBox();
    return box.get(id)?.toEntity();
  }

  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<List<ProductEntity>> fetchProducts({String? query}) => getCachedProducts(query: query);

  @override
  Future<ProductEntity?> fetchProductById(String id) => getCachedProductById(id);

  void _checkSimulationMode() {
    if (simulationMode == SimulationMode.error) {
      throw Exception('Failed to load from cache. Please try again.');
    }
  }
}
