import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../shared/domain/entities/product_entity.dart';

class LocalProductDataSource {
  static const String _assetPath = 'assets/data/products.json';

  Future<List<ProductEntity>> loadProducts() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList.map((item) => _fromJson(item as Map<String, dynamic>)).toList();
  }

  ProductEntity _fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] == 'usd' ? Currency.usd : Currency.bob,
      stock: json['stock'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
