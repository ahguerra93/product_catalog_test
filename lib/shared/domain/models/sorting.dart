import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/order_by.dart';
import '../enums/sort_type.dart';

part 'sorting.freezed.dart';

@freezed
class Sorting with _$Sorting {
  const factory Sorting({required OrderBy orderBy, required SortType sortType}) = _Sorting;

  const Sorting._();

  factory Sorting.defaultSort() => const Sorting(orderBy: OrderBy.asc, sortType: SortType.price);
}
