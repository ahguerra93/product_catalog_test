import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:product_catalog_test/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late StartupRepositoryImpl repository;
  late MockProductHiveDataSource mockHiveDataSource;
  late MockLocalProductDataSource mockLocalDataSource;

  const tProducts = [
    ProductEntity(
      id: '1',
      name: 'Test Product',
      sku: 'TST-001',
      price: 99.99,
      currency: Currency.usd,
      stock: 10,
      imageUrl: 'https://example.com/img.jpg',
    ),
  ];

  setUp(() {
    mockHiveDataSource = MockProductHiveDataSource();
    mockLocalDataSource = MockLocalProductDataSource();
    repository = StartupRepositoryImpl(
      productHiveDataSource: mockHiveDataSource,
      localProductDataSource: mockLocalDataSource,
    );
  });

  group('StartupRepositoryImpl', () {
    group('initializeData', () {
      test('does NOT load from local when cache is non-empty', () async {
        when(
          mockHiveDataSource.getCachedProducts(
            filter: anyNamed('filter'),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => tProducts);

        await repository.initializeData();

        verifyNever(mockLocalDataSource.loadProducts());
        verifyNever(mockHiveDataSource.cacheProducts(any));
      });

      test('loads from local and caches when cache is empty', () async {
        when(
          mockHiveDataSource.getCachedProducts(
            filter: anyNamed('filter'),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => []);
        when(mockLocalDataSource.loadProducts()).thenAnswer((_) async => tProducts);
        when(mockHiveDataSource.cacheProducts(any)).thenAnswer((_) async {});

        await repository.initializeData();

        verify(mockLocalDataSource.loadProducts()).called(1);
        verify(mockHiveDataSource.cacheProducts(tProducts)).called(1);
      });

      test('propagates exception from getCachedProducts', () async {
        when(
          mockHiveDataSource.getCachedProducts(
            filter: anyNamed('filter'),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          ),
        ).thenThrow(Exception('Cache error'));

        expect(() => repository.initializeData(), throwsA(isA<Exception>()));
      });

      test('propagates exception from loadProducts', () async {
        when(
          mockHiveDataSource.getCachedProducts(
            filter: anyNamed('filter'),
            offset: anyNamed('offset'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => []);
        when(mockLocalDataSource.loadProducts()).thenThrow(Exception('Asset load error'));

        expect(() => repository.initializeData(), throwsA(isA<Exception>()));
      });
    });
  });
}
