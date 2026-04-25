import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/shared/domain/models/price_range.dart';

void main() {
  group('PriceRange', () {
    group('isEmpty', () {
      test('returns true when both min and max are null', () {
        const range = PriceRange();
        expect(range.isEmpty, isTrue);
      });

      test('returns false when minPrice is set', () {
        const range = PriceRange(minPrice: 10.0);
        expect(range.isEmpty, isFalse);
      });

      test('returns false when maxPrice is set', () {
        const range = PriceRange(maxPrice: 500.0);
        expect(range.isEmpty, isFalse);
      });

      test('returns false when both are set', () {
        const range = PriceRange(minPrice: 10.0, maxPrice: 500.0);
        expect(range.isEmpty, isFalse);
      });
    });

    group('isValid', () {
      test('returns true when empty', () {
        const range = PriceRange();
        expect(range.isValid, isTrue);
      });

      test('returns true when only minPrice is set', () {
        const range = PriceRange(minPrice: 100.0);
        expect(range.isValid, isTrue);
      });

      test('returns true when only maxPrice is set', () {
        const range = PriceRange(maxPrice: 500.0);
        expect(range.isValid, isTrue);
      });

      test('returns true when minPrice <= maxPrice', () {
        const range = PriceRange(minPrice: 10.0, maxPrice: 500.0);
        expect(range.isValid, isTrue);
      });

      test('returns true when minPrice equals maxPrice', () {
        const range = PriceRange(minPrice: 100.0, maxPrice: 100.0);
        expect(range.isValid, isTrue);
      });

      test('returns false when minPrice > maxPrice', () {
        const range = PriceRange(minPrice: 500.0, maxPrice: 10.0);
        expect(range.isValid, isFalse);
      });
    });

    group('equality', () {
      test('two ranges with same values are equal', () {
        const a = PriceRange(minPrice: 10.0, maxPrice: 500.0);
        const b = PriceRange(minPrice: 10.0, maxPrice: 500.0);
        expect(a, equals(b));
      });
    });
  });
}
