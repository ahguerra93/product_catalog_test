import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

enum Currency { usd, bob }

@freezed
class ProductEntity with _$ProductEntity {
  const ProductEntity._();

  const factory ProductEntity({
    required String id,
    required String name,
    required String sku,
    required double price,
    required Currency currency,
    required int stock,
    required String imageUrl,
  }) = _ProductEntity;

  String get formattedPrice {
    final symbol = currency == Currency.usd ? '\$' : 'Bs. ';
    return '$symbol${price.toStringAsFixed(2)}';
  }

  String get currencyLabel => currency == Currency.usd ? 'USD' : 'BOB';
}
