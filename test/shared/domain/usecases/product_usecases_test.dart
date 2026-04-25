import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:product_catalog_test/features/product_detail/domain/usecases/get_product_by_id_usecase.dart';
import 'package:product_catalog_test/features/product_detail/domain/usecases/update_product_usecase.dart';
import 'package:product_catalog_test/features/product_list/domain/usecases/get_products_usecase.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';
import 'package:product_catalog_test/shared/domain/models/filter_query.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockProductRepository mockRepository;

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
    mockRepository = MockProductRepository();
  });

  group('GetProductsUseCase', () {
    late GetProductsUseCase useCase;

    setUp(() {
      useCase = GetProductsUseCase(repository: mockRepository);
    });

    test('returns list of products from repository', () async {
      when(
        mockRepository.fetchProducts(filter: anyNamed('filter'), offset: anyNamed('offset'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => tProductList);

      final result = await useCase();

      expect(result, equals(tProductList));
    });

    test('passes filter, offset and limit to repository', () async {
      const filter = FilterQuery(query: 'test');
      when(mockRepository.fetchProducts(filter: filter, offset: 5, limit: 20)).thenAnswer((_) async => tProductList);

      final result = await useCase(filter: filter, offset: 5, limit: 20);

      expect(result, equals(tProductList));
      verify(mockRepository.fetchProducts(filter: filter, offset: 5, limit: 20)).called(1);
    });

    test('returns empty list when repository returns empty', () async {
      when(
        mockRepository.fetchProducts(filter: anyNamed('filter'), offset: anyNamed('offset'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => []);

      final result = await useCase();

      expect(result, isEmpty);
    });

    test('propagates exception from repository', () async {
      when(
        mockRepository.fetchProducts(filter: anyNamed('filter'), offset: anyNamed('offset'), limit: anyNamed('limit')),
      ).thenThrow(Exception('Network error'));

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });

  group('GetProductByIdUseCase', () {
    late GetProductByIdUseCase useCase;

    setUp(() {
      useCase = GetProductByIdUseCase(repository: mockRepository);
    });

    test('returns product from repository', () async {
      when(mockRepository.fetchProductById('1')).thenAnswer((_) async => tProduct);

      final result = await useCase('1');

      expect(result, equals(tProduct));
      verify(mockRepository.fetchProductById('1')).called(1);
    });

    test('returns null when product not found', () async {
      when(mockRepository.fetchProductById(any)).thenAnswer((_) async => null);

      final result = await useCase('99');

      expect(result, isNull);
    });

    test('propagates exception from repository', () async {
      when(mockRepository.fetchProductById(any)).thenThrow(Exception('Not found'));

      expect(() => useCase('1'), throwsA(isA<Exception>()));
    });
  });

  group('UpdateProductUseCase', () {
    late UpdateProductUseCase useCase;

    setUp(() {
      useCase = UpdateProductUseCase(repository: mockRepository);
    });

    test('returns updated product from repository', () async {
      when(mockRepository.updateProduct(tProduct)).thenAnswer((_) async => tProduct);

      final result = await useCase(tProduct);

      expect(result, equals(tProduct));
      verify(mockRepository.updateProduct(tProduct)).called(1);
    });

    test('returns null when repository returns null', () async {
      when(mockRepository.updateProduct(any)).thenAnswer((_) async => null);

      final result = await useCase(tProduct);

      expect(result, isNull);
    });

    test('propagates exception from repository', () async {
      when(mockRepository.updateProduct(any)).thenThrow(Exception('Update failed'));

      expect(() => useCase(tProduct), throwsA(isA<Exception>()));
    });
  });
}
