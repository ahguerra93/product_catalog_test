import 'package:product_catalog_test/common/app_strings.dart';

enum OrderBy {
  asc(AppStrings.ascending),
  desc(AppStrings.descending);

  final String label;

  const OrderBy(this.label);
}
