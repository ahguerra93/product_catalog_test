import 'package:product_catalog_test/common/app_strings.dart';

enum SortType {
  price(AppStrings.sortByPrice),
  name(AppStrings.sortByName),
  sku(AppStrings.sortBySku);

  final String label;

  const SortType(this.label);
}
