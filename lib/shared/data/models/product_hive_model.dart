import 'package:hive/hive.dart';
import '../../domain/entities/product_entity.dart';

class ProductHiveModel {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int currencyIndex;
  final int stock;
  final String imageUrl;

  const ProductHiveModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.currencyIndex,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductHiveModel.fromEntity(ProductEntity entity) => ProductHiveModel(
    id: entity.id,
    name: entity.name,
    sku: entity.sku,
    price: entity.price,
    currencyIndex: entity.currency.index,
    stock: entity.stock,
    imageUrl: entity.imageUrl,
  );

  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    sku: sku,
    price: price,
    currency: Currency.values[currencyIndex],
    stock: stock,
    imageUrl: imageUrl,
  );

  Currency get currency => Currency.values[currencyIndex];
}

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 0;

  @override
  ProductHiveModel read(BinaryReader reader) {
    return ProductHiveModel(
      id: reader.readString(),
      name: reader.readString(),
      sku: reader.readString(),
      price: reader.readDouble(),
      currencyIndex: reader.readInt(),
      stock: reader.readInt(),
      imageUrl: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.sku);
    writer.writeDouble(obj.price);
    writer.writeInt(obj.currencyIndex);
    writer.writeInt(obj.stock);
    writer.writeString(obj.imageUrl);
  }
}
