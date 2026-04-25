import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/features/startup/data/datasources/local_faker_product_datasource.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';

void main() {
  group('LocalFakerProductDataSource', () {
    late LocalFakerProductDataSource dataSource;

    setUp(() {
      dataSource = LocalFakerProductDataSource();
    });

    test('loadProducts returns 20 products', () async {
      final products = await dataSource.loadProducts();
      expect(products.length, 20);
    });

    test('loadProducts returns list of ProductEntity', () async {
      final products = await dataSource.loadProducts();
      expect(products, isA<List<ProductEntity>>());
    });

    test('all products have non-empty ids', () async {
      final products = await dataSource.loadProducts();
      for (final p in products) {
        expect(p.id, isNotEmpty);
      }
    });

    test('all products have non-empty names', () async {
      final products = await dataSource.loadProducts();
      for (final p in products) {
        expect(p.name, isNotEmpty);
      }
    });

    test('all products have positive prices', () async {
      final products = await dataSource.loadProducts();
      for (final p in products) {
        expect(p.price, greaterThan(0));
      }
    });

    test('all products have a valid currency', () async {
      final products = await dataSource.loadProducts();
      for (final p in products) {
        expect(Currency.values.contains(p.currency), isTrue);
      }
    });

    test('all products have non-negative stock', () async {
      final products = await dataSource.loadProducts();
      for (final p in products) {
        expect(p.stock, greaterThanOrEqualTo(0));
      }
    });

    test('all products have a non-empty imageUrl', () async {
      final products = await dataSource.loadProducts();
      for (final p in products) {
        expect(p.imageUrl, isNotEmpty);
      }
    });

    test('each call returns products with unique ids', () async {
      final products = await dataSource.loadProducts();
      final ids = products.map((p) => p.id).toSet();
      expect(ids.length, products.length);
    });
  });
}
