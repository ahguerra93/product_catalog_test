import 'package:get_it/get_it.dart';
import '../shared/di/shared_di.dart';
import '../features/product_list/di/product_list_di.dart';
import '../features/product_detail/di/product_detail_di.dart';
import '../features/settings/di/settings_di.dart';
import '../features/startup/di/startup_di.dart';

final GetIt getIt = GetIt.instance;

void initDependencies() {
  initSharedDependencies(getIt);
  initSettingsDependencies(getIt);
  initProductListDependencies(getIt);
  initProductDetailDependencies(getIt);
  initStartupDependencies(getIt);
}
