import 'package:get_it/get_it.dart';
import '../presentation/cubits/settings_cubit.dart';

void initSettingsDependencies(GetIt getIt) {
  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
}
