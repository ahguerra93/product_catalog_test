import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_params.freezed.dart';

@freezed
class PaginationParams with _$PaginationParams {
  const factory PaginationParams({
    required int offset,
    required int limit,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _PaginationParams;

  factory PaginationParams.empty() => const PaginationParams(offset: 0, limit: 10, hasMore: true, isLoadingMore: false);

  const PaginationParams._();

  /// Calculate next page offset
  PaginationParams nextPage() => copyWith(offset: offset + limit);

  /// Mark as currently loading more
  PaginationParams markLoadingMore() => copyWith(isLoadingMore: true);

  /// Update hasMore flag and clear loading flag
  PaginationParams updateHasMore(bool more) => copyWith(hasMore: more, isLoadingMore: false);
}
