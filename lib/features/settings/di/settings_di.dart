import 'package:get_it/get_it.dart';
import '../../../shared/data/datasources/product_hive_datasource.dart';
import '../presentation/cubits/settings_cubit.dart';

void initSettingsDependencies(GetIt getIt) {
  getIt.registerSingleton<SettingsCubit>(SettingsCubit(hiveDataSource: getIt<ProductHiveDataSource>()));
}
