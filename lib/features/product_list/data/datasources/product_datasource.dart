import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/enums/simulation_mode.dart';

abstract class ProductDataSource {
  Future<List<ProductEntity>> fetchProducts();
  Future<ProductEntity?> fetchProductById(String id);
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
  Future<List<ProductEntity>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return switch (simulationMode) {
      SimulationMode.success => List.from(_mockProducts),
      SimulationMode.empty => [],
      SimulationMode.error => throw Exception('Failed to load products. Please try again.'),
    };
  }

  @override
  Future<ProductEntity?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return switch (simulationMode) {
      SimulationMode.success => _mockProducts.where((p) => p.id == id).firstOrNull,
      SimulationMode.empty => null,
      SimulationMode.error => throw Exception('Failed to load product detail.'),
    };
  }
}
