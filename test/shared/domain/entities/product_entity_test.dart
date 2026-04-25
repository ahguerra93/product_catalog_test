import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';

void main() {
  const tProduct = ProductEntity(
    id: '1',
    name: 'Wireless Headphones Pro',
    sku: 'WHP-001',
    price: 149.99,
    currency: Currency.usd,
    stock: 42,
    imageUrl: 'https://example.com/image.jpg',
  );

  group('ProductEntity', () {
    group('formattedPrice', () {
      test('formats USD price with dollar sign', () {
        expect(tProduct.formattedPrice, '\$149.99');
      });

      test('formats BOB price with Bs. prefix', () {
        const bobProduct = ProductEntity(
          id: '2',
          name: 'Test',
          sku: 'T-001',
          price: 350.00,
          currency: Currency.bob,
          stock: 5,
          imageUrl: '',
        );
        expect(bobProduct.formattedPrice, 'Bs. 350.00');
      });

      test('formats price with two decimal places', () {
        const product = ProductEntity(
          id: '3',
          name: 'Test',
          sku: 'T-002',
          price: 10.0,
          currency: Currency.usd,
          stock: 1,
          imageUrl: '',
        );
        expect(product.formattedPrice, '\$10.00');
      });
    });

    group('currencyLabel', () {
      test('returns USD for usd currency', () {
        expect(tProduct.currencyLabel, 'USD');
      });

      test('returns BOB for bob currency', () {
        const bobProduct = ProductEntity(
          id: '2',
          name: 'Test',
          sku: 'T-001',
          price: 100.0,
          currency: Currency.bob,
          stock: 1,
          imageUrl: '',
        );
        expect(bobProduct.currencyLabel, 'BOB');
      });
    });

    group('empty factory', () {
      test('creates entity with empty/zero values', () {
        final empty = ProductEntity.empty();
        expect(empty.id, '');
        expect(empty.name, '');
        expect(empty.sku, '');
        expect(empty.price, 0.0);
        expect(empty.currency, Currency.usd);
        expect(empty.stock, 0);
        expect(empty.imageUrl, '');
      });
    });

    group('equality', () {
      test('two entities with same values are equal', () {
        const product1 = ProductEntity(
          id: '1',
          name: 'Wireless Headphones Pro',
          sku: 'WHP-001',
          price: 149.99,
          currency: Currency.usd,
          stock: 42,
          imageUrl: 'https://example.com/image.jpg',
        );
        expect(product1, equals(tProduct));
      });

      test('two entities with different ids are not equal', () {
        const product2 = ProductEntity(
          id: '99',
          name: 'Wireless Headphones Pro',
          sku: 'WHP-001',
          price: 149.99,
          currency: Currency.usd,
          stock: 42,
          imageUrl: 'https://example.com/image.jpg',
        );
        expect(product2, isNot(equals(tProduct)));
      });
    });

    group('copyWith', () {
      test('copies with updated name', () {
        final updated = tProduct.copyWith(name: 'Updated Name');
        expect(updated.name, 'Updated Name');
        expect(updated.id, tProduct.id);
        expect(updated.price, tProduct.price);
      });

      test('copies with updated price and currency', () {
        final updated = tProduct.copyWith(price: 200.0, currency: Currency.bob);
        expect(updated.price, 200.0);
        expect(updated.currency, Currency.bob);
        expect(updated.id, tProduct.id);
      });
    });
  });

  group('Currency', () {
    test('usd has correct code', () {
      expect(Currency.usd.code, 'USD');
    });

    test('usd has correct displayLabel', () {
      expect(Currency.usd.displayLabel, '\$');
    });

    test('bob has correct code', () {
      expect(Currency.bob.code, 'BOB');
    });

    test('bob has correct displayLabel', () {
      expect(Currency.bob.displayLabel, 'Bs');
    });
  });
}
