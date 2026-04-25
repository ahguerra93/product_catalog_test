// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FilterQuery {
  String? get query => throw _privateConstructorUsedError;
  Currency? get currency => throw _privateConstructorUsedError;
  PriceRange? get priceRange => throw _privateConstructorUsedError;
  bool get inStockOnly => throw _privateConstructorUsedError;
  Sorting? get sorting => throw _privateConstructorUsedError;

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterQueryCopyWith<FilterQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterQueryCopyWith<$Res> {
  factory $FilterQueryCopyWith(
    FilterQuery value,
    $Res Function(FilterQuery) then,
  ) = _$FilterQueryCopyWithImpl<$Res, FilterQuery>;
  @useResult
  $Res call({
    String? query,
    Currency? currency,
    PriceRange? priceRange,
    bool inStockOnly,
    Sorting? sorting,
  });

  $PriceRangeCopyWith<$Res>? get priceRange;
  $SortingCopyWith<$Res>? get sorting;
}

/// @nodoc
class _$FilterQueryCopyWithImpl<$Res, $Val extends FilterQuery>
    implements $FilterQueryCopyWith<$Res> {
  _$FilterQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? currency = freezed,
    Object? priceRange = freezed,
    Object? inStockOnly = null,
    Object? sorting = freezed,
  }) {
    return _then(
      _value.copyWith(
            query: freezed == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as Currency?,
            priceRange: freezed == priceRange
                ? _value.priceRange
                : priceRange // ignore: cast_nullable_to_non_nullable
                      as PriceRange?,
            inStockOnly: null == inStockOnly
                ? _value.inStockOnly
                : inStockOnly // ignore: cast_nullable_to_non_nullable
                      as bool,
            sorting: freezed == sorting
                ? _value.sorting
                : sorting // ignore: cast_nullable_to_non_nullable
                      as Sorting?,
          )
          as $Val,
    );
  }

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceRangeCopyWith<$Res>? get priceRange {
    if (_value.priceRange == null) {
      return null;
    }

    return $PriceRangeCopyWith<$Res>(_value.priceRange!, (value) {
      return _then(_value.copyWith(priceRange: value) as $Val);
    });
  }

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SortingCopyWith<$Res>? get sorting {
    if (_value.sorting == null) {
      return null;
    }

    return $SortingCopyWith<$Res>(_value.sorting!, (value) {
      return _then(_value.copyWith(sorting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FilterQueryImplCopyWith<$Res>
    implements $FilterQueryCopyWith<$Res> {
  factory _$$FilterQueryImplCopyWith(
    _$FilterQueryImpl value,
    $Res Function(_$FilterQueryImpl) then,
  ) = __$$FilterQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? query,
    Currency? currency,
    PriceRange? priceRange,
    bool inStockOnly,
    Sorting? sorting,
  });

  @override
  $PriceRangeCopyWith<$Res>? get priceRange;
  @override
  $SortingCopyWith<$Res>? get sorting;
}

/// @nodoc
class __$$FilterQueryImplCopyWithImpl<$Res>
    extends _$FilterQueryCopyWithImpl<$Res, _$FilterQueryImpl>
    implements _$$FilterQueryImplCopyWith<$Res> {
  __$$FilterQueryImplCopyWithImpl(
    _$FilterQueryImpl _value,
    $Res Function(_$FilterQueryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? currency = freezed,
    Object? priceRange = freezed,
    Object? inStockOnly = null,
    Object? sorting = freezed,
  }) {
    return _then(
      _$FilterQueryImpl(
        query: freezed == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as Currency?,
        priceRange: freezed == priceRange
            ? _value.priceRange
            : priceRange // ignore: cast_nullable_to_non_nullable
                  as PriceRange?,
        inStockOnly: null == inStockOnly
            ? _value.inStockOnly
            : inStockOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
        sorting: freezed == sorting
            ? _value.sorting
            : sorting // ignore: cast_nullable_to_non_nullable
                  as Sorting?,
      ),
    );
  }
}

/// @nodoc

class _$FilterQueryImpl extends _FilterQuery {
  const _$FilterQueryImpl({
    this.query,
    this.currency,
    this.priceRange,
    this.inStockOnly = false,
    this.sorting,
  }) : super._();

  @override
  final String? query;
  @override
  final Currency? currency;
  @override
  final PriceRange? priceRange;
  @override
  @JsonKey()
  final bool inStockOnly;
  @override
  final Sorting? sorting;

  @override
  String toString() {
    return 'FilterQuery(query: $query, currency: $currency, priceRange: $priceRange, inStockOnly: $inStockOnly, sorting: $sorting)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterQueryImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.priceRange, priceRange) ||
                other.priceRange == priceRange) &&
            (identical(other.inStockOnly, inStockOnly) ||
                other.inStockOnly == inStockOnly) &&
            (identical(other.sorting, sorting) || other.sorting == sorting));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    currency,
    priceRange,
    inStockOnly,
    sorting,
  );

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterQueryImplCopyWith<_$FilterQueryImpl> get copyWith =>
      __$$FilterQueryImplCopyWithImpl<_$FilterQueryImpl>(this, _$identity);
}

abstract class _FilterQuery extends FilterQuery {
  const factory _FilterQuery({
    final String? query,
    final Currency? currency,
    final PriceRange? priceRange,
    final bool inStockOnly,
    final Sorting? sorting,
  }) = _$FilterQueryImpl;
  const _FilterQuery._() : super._();

  @override
  String? get query;
  @override
  Currency? get currency;
  @override
  PriceRange? get priceRange;
  @override
  bool get inStockOnly;
  @override
  Sorting? get sorting;

  /// Create a copy of FilterQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterQueryImplCopyWith<_$FilterQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
