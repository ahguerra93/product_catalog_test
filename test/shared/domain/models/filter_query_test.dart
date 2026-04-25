import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/shared/domain/models/filter_query.dart';
import 'package:product_catalog_test/shared/domain/models/price_range.dart';
import 'package:product_catalog_test/shared/domain/models/sorting.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';
import 'package:product_catalog_test/shared/domain/enums/order_by.dart';
import 'package:product_catalog_test/shared/domain/enums/sort_type.dart';

void main() {
  group('FilterQuery', () {
    group('hasActiveFilters', () {
      test('returns false for empty filter', () {
        final filter = FilterQuery.empty();
        expect(filter.hasActiveFilters, isFalse);
      });

      test('returns false for default constructed filter', () {
        const filter = FilterQuery();
        expect(filter.hasActiveFilters, isFalse);
      });

      test('returns true when query is set', () {
        const filter = FilterQuery(query: 'headphones');
        expect(filter.hasActiveFilters, isTrue);
      });

      test('returns false when query is empty string', () {
        const filter = FilterQuery(query: '');
        expect(filter.hasActiveFilters, isFalse);
      });

      test('returns true when currency is set', () {
        const filter = FilterQuery(currency: Currency.usd);
        expect(filter.hasActiveFilters, isTrue);
      });

      test('returns true when priceRange is non-empty', () {
        const filter = FilterQuery(priceRange: PriceRange(minPrice: 10.0));
        expect(filter.hasActiveFilters, isTrue);
      });

      test('returns false when priceRange is empty (both null)', () {
        const filter = FilterQuery(priceRange: PriceRange());
        expect(filter.hasActiveFilters, isFalse);
      });

      test('returns true when inStockOnly is true', () {
        const filter = FilterQuery(inStockOnly: true);
        expect(filter.hasActiveFilters, isTrue);
      });

      test('returns true when sorting is set', () {
        final filter = FilterQuery(sorting: Sorting.defaultSort());
        expect(filter.hasActiveFilters, isTrue);
      });

      test('returns true when multiple filters are active', () {
        final filter = FilterQuery(
          query: 'keyboard',
          currency: Currency.usd,
          inStockOnly: true,
          sorting: Sorting(orderBy: OrderBy.desc, sortType: SortType.name),
        );
        expect(filter.hasActiveFilters, isTrue);
      });
    });

    group('empty factory', () {
      test('creates filter with no active filters', () {
        final filter = FilterQuery.empty();
        expect(filter.hasActiveFilters, isFalse);
        expect(filter.query, isNull);
        expect(filter.currency, isNull);
        expect(filter.priceRange, isNull);
        expect(filter.inStockOnly, isFalse);
        expect(filter.sorting, isNull);
      });
    });

    group('equality', () {
      test('two empty filters are equal', () {
        expect(FilterQuery.empty(), equals(FilterQuery.empty()));
      });

      test('filters with same values are equal', () {
        const a = FilterQuery(query: 'test', inStockOnly: true);
        const b = FilterQuery(query: 'test', inStockOnly: true);
        expect(a, equals(b));
      });
    });
  });
}
