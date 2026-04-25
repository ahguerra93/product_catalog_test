import 'package:get_it/get_it.dart';
import '../../../features/product_list/data/datasources/product_hive_datasource.dart';
import '../data/datasources/local_product_datasource.dart';
import '../data/repositories/startup_repository_impl.dart';
import '../domain/repositories/startup_repository.dart';
import '../domain/usecases/initialize_app_usecase.dart';
import '../presentation/cubits/startup_cubit.dart';

void initStartupDependencies(GetIt getIt) {
  // Data sources
  getIt.registerSingleton<LocalProductDataSource>(LocalProductDataSource());

  // Repository
  getIt.registerFactory<StartupRepository>(
    () => StartupRepositoryImpl(
      productHiveDataSource: getIt<ProductHiveDataSource>(),
      localProductDataSource: getIt<LocalProductDataSource>(),
    ),
  );

  // Use cases
  getIt.registerFactory<InitializeAppUseCase>(
    () => InitializeAppUseCase(repository: getIt<StartupRepository>()),
  );

  // Cubit
  getIt.registerFactory<StartupCubit>(
    () => StartupCubit(initializeAppUseCase: getIt<InitializeAppUseCase>()),
  );
}
