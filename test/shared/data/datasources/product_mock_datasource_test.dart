import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/config/logger_config.dart';
import 'package:product_catalog_test/di/di.dart';
import 'package:product_catalog_test/shared/data/datasources/product_datasource.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';
import 'package:product_catalog_test/shared/domain/enums/simulation_mode.dart';
import 'package:product_catalog_test/shared/domain/models/filter_query.dart';
import 'package:product_catalog_test/shared/domain/models/price_range.dart';
import 'package:product_catalog_test/shared/domain/models/sorting.dart';
import 'package:product_catalog_test/shared/domain/enums/order_by.dart';
import 'package:product_catalog_test/shared/domain/enums/sort_type.dart';

void main() {
  setUpAll(() {
    if (!getIt.isRegistered<LoggerService>()) {
      getIt.registerSingleton<LoggerService>(const LoggerService());
    }
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  group('ProductMockDataSource', () {
    late ProductMockDataSource dataSource;

    setUp(() {
      dataSource = ProductMockDataSource(simulationMode: SimulationMode.success);
    });

    group('fetchProducts', () {
      test('returns list of products on success mode', () async {
        final products = await dataSource.fetchProducts();
        expect(products, isA<List<ProductEntity>>());
        expect(products, isNotEmpty);
      });

      test('respects limit parameter', () async {
        final products = await dataSource.fetchProducts(limit: 3);
        expect(products.length, lessThanOrEqualTo(3));
      });

      test('respects offset parameter', () async {
        final all = await dataSource.fetchProducts(limit: 100);
        final offset2 = await dataSource.fetchProducts(offset: 2, limit: 100);
        expect(offset2.length, lessThanOrEqualTo(all.length - 2));
      });

      test('returns empty list on empty mode', () async {
        dataSource = ProductMockDataSource(simulationMode: SimulationMode.empty);
        final products = await dataSource.fetchProducts();
        expect(products, isEmpty);
      });

      test('throws exception on error mode', () async {
        dataSource = ProductMockDataSource(simulationMode: SimulationMode.error);
        expect(() => dataSource.fetchProducts(), throwsA(isA<Exception>()));
      });

      test('filters by query matching name', () async {
        final products = await dataSource.fetchProducts(filter: const FilterQuery(query: 'headphones'));
        for (final p in products) {
          expect(p.name.toLowerCase().contains('headphones') || p.sku.toLowerCase().contains('headphones'), isTrue);
        }
      });

      test('filters by currency', () async {
        final products = await dataSource.fetchProducts(filter: const FilterQuery(currency: Currency.usd), limit: 100);
        for (final p in products) {
          expect(p.currency, Currency.usd);
        }
      });

      test('filters by inStockOnly', () async {
        final products = await dataSource.fetchProducts(filter: const FilterQuery(inStockOnly: true), limit: 100);
        for (final p in products) {
          expect(p.stock, greaterThan(0));
        }
      });

      test('filters by price range', () async {
        const range = PriceRange(minPrice: 100.0, maxPrice: 300.0);
        final products = await dataSource.fetchProducts(filter: const FilterQuery(priceRange: range), limit: 100);
        for (final p in products) {
          expect(p.price, greaterThanOrEqualTo(100.0));
          expect(p.price, lessThanOrEqualTo(300.0));
        }
      });

      test('sorts by price ascending', () async {
        final sorting = Sorting(orderBy: OrderBy.asc, sortType: SortType.price);
        final products = await dataSource.fetchProducts(filter: FilterQuery(sorting: sorting), limit: 100);
        for (int i = 1; i < products.length; i++) {
          expect(products[i].price, greaterThanOrEqualTo(products[i - 1].price));
        }
      });

      test('sorts by price descending', () async {
        final sorting = Sorting(orderBy: OrderBy.desc, sortType: SortType.price);
        final products = await dataSource.fetchProducts(filter: FilterQuery(sorting: sorting), limit: 100);
        for (int i = 1; i < products.length; i++) {
          expect(products[i].price, lessThanOrEqualTo(products[i - 1].price));
        }
      });

      test('sorts by name ascending', () async {
        final sorting = Sorting(orderBy: OrderBy.asc, sortType: SortType.name);
        final products = await dataSource.fetchProducts(filter: FilterQuery(sorting: sorting), limit: 100);
        for (int i = 1; i < products.length; i++) {
          expect(products[i].name.compareTo(products[i - 1].name), greaterThanOrEqualTo(0));
        }
      });
    });

    group('fetchProductById', () {
      test('returns product with matching id', () async {
        final product = await dataSource.fetchProductById('1');
        expect(product, isNotNull);
        expect(product!.id, '1');
      });

      test('returns null for non-existing id', () async {
        final product = await dataSource.fetchProductById('non-existent-id');
        expect(product, isNull);
      });

      test('returns null on empty mode', () async {
        dataSource = ProductMockDataSource(simulationMode: SimulationMode.empty);
        final product = await dataSource.fetchProductById('1');
        expect(product, isNull);
      });

      test('throws exception on error mode', () async {
        dataSource = ProductMockDataSource(simulationMode: SimulationMode.error);
        expect(() => dataSource.fetchProductById('1'), throwsA(isA<Exception>()));
      });
    });

    group('updateProduct', () {
      const tProduct = ProductEntity(
        id: '1',
        name: 'Updated Name',
        sku: 'WHP-001',
        price: 199.99,
        currency: Currency.usd,
        stock: 42,
        imageUrl: 'https://example.com/img.jpg',
      );

      test('returns the updated product on success mode', () async {
        final result = await dataSource.updateProduct(tProduct);
        expect(result, equals(tProduct));
      });

      test('returns null on empty mode', () async {
        dataSource = ProductMockDataSource(simulationMode: SimulationMode.empty);
        final result = await dataSource.updateProduct(tProduct);
        expect(result, isNull);
      });

      test('throws exception on error mode', () async {
        dataSource = ProductMockDataSource(simulationMode: SimulationMode.error);
        expect(() => dataSource.updateProduct(tProduct), throwsA(isA<Exception>()));
      });
    });
  });
}
