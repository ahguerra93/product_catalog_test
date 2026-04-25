import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/shared/data/models/product_hive_model.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';

void main() {
  const tEntity = ProductEntity(
    id: 'abc-123',
    name: 'Wireless Headphones Pro',
    sku: 'WHP-001',
    price: 149.99,
    currency: Currency.usd,
    stock: 42,
    imageUrl: 'https://example.com/image.jpg',
  );

  const tEntityBob = ProductEntity(
    id: 'xyz-456',
    name: 'Mochila Táctica',
    sku: 'MTN-004',
    price: 350.00,
    currency: Currency.bob,
    stock: 8,
    imageUrl: 'https://example.com/bag.jpg',
  );

  group('ProductHiveModel', () {
    group('fromEntity', () {
      test('maps all fields correctly for USD product', () {
        final model = ProductHiveModel.fromEntity(tEntity);
        expect(model.id, tEntity.id);
        expect(model.name, tEntity.name);
        expect(model.sku, tEntity.sku);
        expect(model.price, tEntity.price);
        expect(model.currencyIndex, Currency.usd.index);
        expect(model.stock, tEntity.stock);
        expect(model.imageUrl, tEntity.imageUrl);
      });

      test('maps currencyIndex correctly for BOB product', () {
        final model = ProductHiveModel.fromEntity(tEntityBob);
        expect(model.currencyIndex, Currency.bob.index);
      });

      test('maps zero stock correctly', () {
        const zeroStock = ProductEntity(
          id: '5',
          name: 'Out of Stock Item',
          sku: 'OOS-005',
          price: 99.99,
          currency: Currency.usd,
          stock: 0,
          imageUrl: '',
        );
        final model = ProductHiveModel.fromEntity(zeroStock);
        expect(model.stock, 0);
      });
    });

    group('toEntity', () {
      test('maps all fields back to entity for USD product', () {
        final model = ProductHiveModel(
          id: tEntity.id,
          name: tEntity.name,
          sku: tEntity.sku,
          price: tEntity.price,
          currencyIndex: Currency.usd.index,
          stock: tEntity.stock,
          imageUrl: tEntity.imageUrl,
        );
        final entity = model.toEntity();
        expect(entity, equals(tEntity));
      });

      test('maps currency correctly from index', () {
        final model = ProductHiveModel.fromEntity(tEntityBob);
        final entity = model.toEntity();
        expect(entity.currency, Currency.bob);
      });
    });

    group('currency getter', () {
      test('returns correct Currency from currencyIndex', () {
        final model = ProductHiveModel.fromEntity(tEntity);
        expect(model.currency, Currency.usd);
      });

      test('returns BOB currency correctly', () {
        final model = ProductHiveModel.fromEntity(tEntityBob);
        expect(model.currency, Currency.bob);
      });
    });

    group('round-trip conversion', () {
      test('entity -> model -> entity preserves all fields', () {
        final model = ProductHiveModel.fromEntity(tEntity);
        final restored = model.toEntity();
        expect(restored, equals(tEntity));
      });

      test('BOB entity round-trip preserves currency', () {
        final model = ProductHiveModel.fromEntity(tEntityBob);
        final restored = model.toEntity();
        expect(restored, equals(tEntityBob));
      });
    });
  });
}
