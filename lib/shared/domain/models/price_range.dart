import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_range.freezed.dart';

@freezed
class PriceRange with _$PriceRange {
  const factory PriceRange({double? minPrice, double? maxPrice}) = _PriceRange;

  const PriceRange._();

  bool get isEmpty => minPrice == null && maxPrice == null;

  bool get isValid {
    if (isEmpty) return true;
    if (minPrice != null && maxPrice != null) {
      return minPrice! <= maxPrice!;
    }
    return true;
  }
}
