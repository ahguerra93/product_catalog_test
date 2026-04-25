import 'package:mockito/annotations.dart';
import 'package:product_catalog_test/shared/domain/repositories/product_repository.dart';
import 'package:product_catalog_test/shared/data/datasources/product_datasource.dart';
import 'package:product_catalog_test/shared/data/datasources/product_hive_datasource.dart';
import 'package:product_catalog_test/features/startup/data/datasources/local_product_datasource.dart';
import 'package:product_catalog_test/features/startup/domain/repositories/startup_repository.dart';

@GenerateMocks([ProductRepository, ProductDataSource, ProductHiveDataSource, LocalProductDataSource, StartupRepository])
void main() {}
