import 'package:faker_dart/faker_dart.dart';
import 'package:product_catalog_test/features/startup/data/datasources/local_product_datasource.dart';
import '../../../../shared/domain/entities/product_entity.dart';

class LocalFakerProductDataSource implements LocalProductDataSource {
  @override
  Future<List<ProductEntity>> loadProducts() async {
    final faker = Faker.instance;
    return [
      for (int i = 0; i < 20; i++)
        ProductEntity(
          id: faker.datatype.uuid(),
          name: faker.commerce.productName(),
          sku: 'SKU-${faker.datatype.string(length: 8)}',
          price: (faker.datatype.float(max: 1000, min: 10) * 100).truncateToDouble() / 100,
          currency: faker.datatype.boolean() ? Currency.usd : Currency.bob,
          stock: faker.datatype.number(max: 100),
          imageUrl: 'https://picsum.photos/200/300?random=${faker.datatype.number()}',
        ),
    ];
  }
}
