import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:product_catalog_test/config/logger_config.dart';
import 'package:product_catalog_test/shared/data/repositories/product_repository_impl.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';
import 'package:product_catalog_test/shared/domain/models/filter_query.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductDataSource mockDataSource;

  setUpAll(() {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<LoggerService>()) {
      getIt.registerSingleton<LoggerService>(const LoggerService());
    }
  });

  tearDownAll(() async {
    await GetIt.instance.reset();
  });

  const tProduct = ProductEntity(
    id: '1',
    name: 'Wireless Headphones',
    sku: 'WHP-001',
    price: 149.99,
    currency: Currency.usd,
    stock: 42,
    imageUrl: 'https://example.com/img.jpg',
  );

  final tProductList = [tProduct];

  setUp(() {
    mockDataSource = MockProductDataSource();
    repository = ProductRepositoryImpl(dataSource: mockDataSource);
  });

  group('ProductRepositoryImpl', () {
    group('fetchProducts', () {
      test('returns list from data source on success', () async {
        when(
          mockDataSource.fetchProducts(
            filter: anyNamed('filter'),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => tProductList);

        final result = await repository.fetchProducts();

        expect(result, equals(tProductList));
        verify(mockDataSource.fetchProducts(filter: null, offset: 0, limit: 10)).called(1);
      });

      test('passes filter, offset and limit to data source', () async {
        const filter = FilterQuery(query: 'test');
        when(mockDataSource.fetchProducts(filter: filter, offset: 5, limit: 20)).thenAnswer((_) async => tProductList);

        final result = await repository.fetchProducts(filter: filter, offset: 5, limit: 20);

        expect(result, equals(tProductList));
        verify(mockDataSource.fetchProducts(filter: filter, offset: 5, limit: 20)).called(1);
      });

      test('rethrows exception from data source', () async {
        when(
          mockDataSource.fetchProducts(
            filter: anyNamed('filter'),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(() => repository.fetchProducts(), throwsA(isA<Exception>()));
      });
    });

    group('fetchProductById', () {
      test('returns product from data source', () async {
        when(mockDataSource.fetchProductById('1')).thenAnswer((_) async => tProduct);

        final result = await repository.fetchProductById('1');

        expect(result, equals(tProduct));
        verify(mockDataSource.fetchProductById('1')).called(1);
      });

      test('returns null when product not found', () async {
        when(mockDataSource.fetchProductById(any)).thenAnswer((_) async => null);

        final result = await repository.fetchProductById('99');

        expect(result, isNull);
      });

      test('rethrows exception from data source', () async {
        when(mockDataSource.fetchProductById(any)).thenThrow(Exception('Not found'));

        expect(() => repository.fetchProductById('1'), throwsA(isA<Exception>()));
      });
    });

    group('updateProduct', () {
      test('returns updated product from data source', () async {
        when(mockDataSource.updateProduct(tProduct)).thenAnswer((_) async => tProduct);

        final result = await repository.updateProduct(tProduct);

        expect(result, equals(tProduct));
        verify(mockDataSource.updateProduct(tProduct)).called(1);
      });

      test('returns null when update returns null', () async {
        when(mockDataSource.updateProduct(any)).thenAnswer((_) async => null);

        final result = await repository.updateProduct(tProduct);

        expect(result, isNull);
      });

      test('rethrows exception from data source', () async {
        when(mockDataSource.updateProduct(any)).thenThrow(Exception('Update failed'));

        expect(() => repository.updateProduct(tProduct), throwsA(isA<Exception>()));
      });
    });
  });
}
