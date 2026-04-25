import 'package:get_it/get_it.dart';
import '../features/product_list/di/product_list_di.dart';
import '../features/settings/di/settings_di.dart';
import '../features/startup/di/startup_di.dart';

final GetIt getIt = GetIt.instance;

void initDependencies() {
  initSettingsDependencies(getIt);
  initProductListDependencies(getIt);
  initStartupDependencies(getIt);
}
