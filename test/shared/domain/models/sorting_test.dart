import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/common/app_strings.dart';
import 'package:product_catalog_test/shared/domain/models/sorting.dart';
import 'package:product_catalog_test/shared/domain/enums/order_by.dart';
import 'package:product_catalog_test/shared/domain/enums/sort_type.dart';

void main() {
  group('Sorting', () {
    group('defaultSort factory', () {
      test('creates with asc order and price sort type', () {
        final sort = Sorting.defaultSort();
        expect(sort.orderBy, OrderBy.asc);
        expect(sort.sortType, SortType.price);
      });
    });

    group('equality', () {
      test('two sortings with same values are equal', () {
        const a = Sorting(orderBy: OrderBy.asc, sortType: SortType.name);
        const b = Sorting(orderBy: OrderBy.asc, sortType: SortType.name);
        expect(a, equals(b));
      });

      test('sortings with different orderBy are not equal', () {
        const a = Sorting(orderBy: OrderBy.asc, sortType: SortType.price);
        const b = Sorting(orderBy: OrderBy.desc, sortType: SortType.price);
        expect(a, isNot(equals(b)));
      });
    });

    group('copyWith', () {
      test('copies with updated orderBy', () {
        final sort = Sorting.defaultSort();
        final updated = sort.copyWith(orderBy: OrderBy.desc);
        expect(updated.orderBy, OrderBy.desc);
        expect(updated.sortType, SortType.price);
      });
    });
  });

  group('OrderBy', () {
    test('asc has correct label', () {
      expect(OrderBy.asc.label, AppStrings.ascending);
    });

    test('desc has correct label', () {
      expect(OrderBy.desc.label, AppStrings.descending);
    });
  });

  group('SortType', () {
    test('price has correct label', () {
      expect(SortType.price.label, AppStrings.sortByPrice);
    });

    test('name has correct label', () {
      expect(SortType.name.label, AppStrings.sortByName);
    });

    test('sku has correct label', () {
      expect(SortType.sku.label, AppStrings.sortBySku);
    });
  });
}
