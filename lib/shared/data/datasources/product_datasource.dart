import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/enums/sort_type.dart';
import '../../../../shared/domain/enums/simulation_mode.dart';
import '../../domain/models/filter_query.dart';
import '../../../config/logger_config.dart';
import '../../../di/di.dart';

abstract class ProductDataSource {
  Future<List<ProductEntity>> fetchProducts({FilterQuery? filter, int offset = 0, int limit = 10});
  Future<ProductEntity?> fetchProductById(String id);
  Future<ProductEntity?> updateProduct(ProductEntity product);
}

class ProductMockDataSource implements ProductDataSource {
  SimulationMode simulationMode;

  ProductMockDataSource({this.simulationMode = SimulationMode.success});

  static final List<ProductEntity> _mockProducts = [
    const ProductEntity(
      id: '1',
      name: 'Wireless Headphones Pro',
      sku: 'WHP-001',
      price: 149.99,
      currency: Currency.usd,
      stock: 42,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
    ),
    const ProductEntity(
      id: '2',
      name: 'Smart Watch Series X',
      sku: 'SWX-002',
      price: 299.99,
      currency: Currency.usd,
      stock: 15,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
    ),
    const ProductEntity(
      id: '3',
      name: 'Laptop Stand Aluminum',
      sku: 'LSA-003',
      price: 79.00,
      currency: Currency.usd,
      stock: 120,
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600',
    ),
    const ProductEntity(
      id: '4',
      name: 'Mochila Táctica Negro',
      sku: 'MTN-004',
      price: 350.00,
      currency: Currency.bob,
      stock: 8,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
    ),
    const ProductEntity(
      id: '5',
      name: 'Mechanical Keyboard TKL',
      sku: 'MKT-005',
      price: 119.95,
      currency: Currency.usd,
      stock: 0,
      imageUrl: 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?w=600',
    ),
    const ProductEntity(
      id: '6',
      name: 'Cable USB-C 2m Premium',
      sku: 'CUC-006',
      price: 45.00,
      currency: Currency.bob,
      stock: 200,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600',
    ),
    const ProductEntity(
      id: '7',
      name: '4K Portable Monitor',
      sku: 'PM4K-007',
      price: 389.00,
      currency: Currency.usd,
      stock: 5,
      imageUrl: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600',
    ),
    const ProductEntity(
      id: '8',
      name: 'Mouse Inalámbrico Ergonómico',
      sku: 'MIE-008',
      price: 180.00,
      currency: Currency.bob,
      stock: 33,
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600',
    ),
  ];

  @override
  Future<List<ProductEntity>> fetchProducts({FilterQuery? filter, int offset = 0, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final List<ProductEntity> products = switch (simulationMode) {
      SimulationMode.success => List.from(_mockProducts),
      SimulationMode.empty => [],
      SimulationMode.error => throw Exception('Failed to load products. Please try again.'),
    };

    if (filter == null || !filter.hasActiveFilters) {
      final paginated = products.skip(offset).take(limit).toList();
      getIt<LoggerService>().logDataAsJson('ProductMockDataSource.fetchProducts', paginated);
      return paginated;
    }

    // Apply filters
    var filtered = products;

    // Filter by query (name or SKU)
    if (filter.query != null && filter.query!.isNotEmpty) {
      final q = filter.query!.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q);
      }).toList();
    }

    // Filter by currency
    if (filter.currency != null) {
      filtered = filtered.where((p) => p.currency == filter.currency).toList();
    }

    // Filter by price range
    if (filter.priceRange != null && filter.priceRange!.isValid) {
      final minPrice = filter.priceRange!.minPrice ?? 0;
      final maxPrice = filter.priceRange!.maxPrice ?? double.infinity;
      filtered = filtered.where((p) => p.price >= minPrice && p.price <= maxPrice).toList();
    }

    // Filter by stock
    if (filter.inStockOnly) {
      filtered = filtered.where((p) => p.stock > 0).toList();
    }

    // Sort by price
    if (filter.sorting != null) {
      filtered.sort((a, b) {
        final comparison = switch (filter.sorting!.sortType) {
          SortType.price => a.price.compareTo(b.price),
          SortType.name => a.name.compareTo(b.name),
          SortType.sku => a.sku.compareTo(b.sku),
        };
        return filter.sorting!.orderBy.name == 'asc' ? comparison : -comparison;
      });
    }

    // Apply pagination after filtering
    final paginated = filtered.skip(offset).take(limit).toList();
    getIt<LoggerService>().logDataAsJson('ProductMockDataSource.fetchProducts', paginated);
    return paginated;
  }

  @override
  Future<ProductEntity?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final product = switch (simulationMode) {
      SimulationMode.success => _mockProducts.where((p) => p.id == id).firstOrNull,
      SimulationMode.empty => null,
      SimulationMode.error => throw Exception('Failed to load product detail.'),
    };

    getIt<LoggerService>().logDatasourceFetch(
      'ProductMockDataSource',
      'fetchProductById',
      success: true,
      data: product != null ? 'ID: $id' : null,
    );
    return product;
  }

  @override
  Future<ProductEntity?> updateProduct(ProductEntity product) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final result = switch (simulationMode) {
      SimulationMode.success => product,
      SimulationMode.empty => null,
      SimulationMode.error => throw Exception('Failed to update product.'),
    };

    getIt<LoggerService>().logDatasourceFetch(
      'ProductMockDataSource',
      'updateProduct',
      success: true,
      data: 'Product: ${product.id}',
    );
    return result;
  }
}
