import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/product_entity.dart';
import '../models/sorting.dart';
import 'price_range.dart';

part 'filter_query.freezed.dart';

@freezed
class FilterQuery with _$FilterQuery {
  const factory FilterQuery({
    String? query,
    Currency? currency,
    PriceRange? priceRange,
    @Default(false) bool inStockOnly,
    Sorting? sorting,
  }) = _FilterQuery;

  const FilterQuery._();

  bool get hasActiveFilters {
    return (query != null && query!.isNotEmpty) ||
        currency != null ||
        (priceRange != null && !priceRange!.isEmpty) ||
        inStockOnly ||
        sorting != null;
  }

  factory FilterQuery.empty() => const FilterQuery();
}
