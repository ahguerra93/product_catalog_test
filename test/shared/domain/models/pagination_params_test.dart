import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/shared/domain/models/pagination_params.dart';

void main() {
  group('PaginationParams', () {
    group('empty factory', () {
      test('creates with offset=0, limit=10, hasMore=true, isLoadingMore=false', () {
        final params = PaginationParams.empty();
        expect(params.offset, 0);
        expect(params.limit, 10);
        expect(params.hasMore, isTrue);
        expect(params.isLoadingMore, isFalse);
      });
    });

    group('nextPage', () {
      test('increments offset by limit', () {
        final params = PaginationParams.empty();
        final next = params.nextPage();
        expect(next.offset, 10);
        expect(next.limit, 10);
      });

      test('increments offset correctly for custom limit', () {
        const params = PaginationParams(offset: 20, limit: 5, hasMore: true);
        final next = params.nextPage();
        expect(next.offset, 25);
        expect(next.limit, 5);
      });

      test('does not change limit when advancing page', () {
        final params = PaginationParams.empty();
        final next = params.nextPage();
        expect(next.limit, params.limit);
      });
    });

    group('markLoadingMore', () {
      test('sets isLoadingMore to true', () {
        final params = PaginationParams.empty();
        final loading = params.markLoadingMore();
        expect(loading.isLoadingMore, isTrue);
      });

      test('preserves other fields', () {
        const params = PaginationParams(offset: 10, limit: 5, hasMore: true);
        final loading = params.markLoadingMore();
        expect(loading.offset, 10);
        expect(loading.limit, 5);
        expect(loading.hasMore, isTrue);
      });
    });

    group('updateHasMore', () {
      test('sets hasMore to true and resets isLoadingMore', () {
        const params = PaginationParams(offset: 0, limit: 10, hasMore: false, isLoadingMore: true);
        final updated = params.updateHasMore(true);
        expect(updated.hasMore, isTrue);
        expect(updated.isLoadingMore, isFalse);
      });

      test('sets hasMore to false and resets isLoadingMore', () {
        const params = PaginationParams(offset: 0, limit: 10, hasMore: true, isLoadingMore: true);
        final updated = params.updateHasMore(false);
        expect(updated.hasMore, isFalse);
        expect(updated.isLoadingMore, isFalse);
      });

      test('preserves offset and limit', () {
        const params = PaginationParams(offset: 30, limit: 15, hasMore: true);
        final updated = params.updateHasMore(false);
        expect(updated.offset, 30);
        expect(updated.limit, 15);
      });
    });

    group('equality', () {
      test('two params with same values are equal', () {
        const a = PaginationParams(offset: 0, limit: 10, hasMore: true);
        const b = PaginationParams(offset: 0, limit: 10, hasMore: true);
        expect(a, equals(b));
      });
    });
  });
}
