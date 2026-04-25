// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sorting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Sorting {
  OrderBy get orderBy => throw _privateConstructorUsedError;
  SortType get sortType => throw _privateConstructorUsedError;

  /// Create a copy of Sorting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SortingCopyWith<Sorting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortingCopyWith<$Res> {
  factory $SortingCopyWith(Sorting value, $Res Function(Sorting) then) =
      _$SortingCopyWithImpl<$Res, Sorting>;
  @useResult
  $Res call({OrderBy orderBy, SortType sortType});
}

/// @nodoc
class _$SortingCopyWithImpl<$Res, $Val extends Sorting>
    implements $SortingCopyWith<$Res> {
  _$SortingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sorting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orderBy = null, Object? sortType = null}) {
    return _then(
      _value.copyWith(
            orderBy: null == orderBy
                ? _value.orderBy
                : orderBy // ignore: cast_nullable_to_non_nullable
                      as OrderBy,
            sortType: null == sortType
                ? _value.sortType
                : sortType // ignore: cast_nullable_to_non_nullable
                      as SortType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SortingImplCopyWith<$Res> implements $SortingCopyWith<$Res> {
  factory _$$SortingImplCopyWith(
    _$SortingImpl value,
    $Res Function(_$SortingImpl) then,
  ) = __$$SortingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OrderBy orderBy, SortType sortType});
}

/// @nodoc
class __$$SortingImplCopyWithImpl<$Res>
    extends _$SortingCopyWithImpl<$Res, _$SortingImpl>
    implements _$$SortingImplCopyWith<$Res> {
  __$$SortingImplCopyWithImpl(
    _$SortingImpl _value,
    $Res Function(_$SortingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Sorting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orderBy = null, Object? sortType = null}) {
    return _then(
      _$SortingImpl(
        orderBy: null == orderBy
            ? _value.orderBy
            : orderBy // ignore: cast_nullable_to_non_nullable
                  as OrderBy,
        sortType: null == sortType
            ? _value.sortType
            : sortType // ignore: cast_nullable_to_non_nullable
                  as SortType,
      ),
    );
  }
}

/// @nodoc

class _$SortingImpl extends _Sorting {
  const _$SortingImpl({required this.orderBy, required this.sortType})
    : super._();

  @override
  final OrderBy orderBy;
  @override
  final SortType sortType;

  @override
  String toString() {
    return 'Sorting(orderBy: $orderBy, sortType: $sortType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortingImpl &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderBy, sortType);

  /// Create a copy of Sorting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SortingImplCopyWith<_$SortingImpl> get copyWith =>
      __$$SortingImplCopyWithImpl<_$SortingImpl>(this, _$identity);
}

abstract class _Sorting extends Sorting {
  const factory _Sorting({
    required final OrderBy orderBy,
    required final SortType sortType,
  }) = _$SortingImpl;
  const _Sorting._() : super._();

  @override
  OrderBy get orderBy;
  @override
  SortType get sortType;

  /// Create a copy of Sorting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortingImplCopyWith<_$SortingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
