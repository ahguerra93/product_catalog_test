import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_theme.dart';
import 'config/routing/router.dart';
import 'di/di.dart';
import 'features/settings/presentation/cubits/settings_cubit.dart';
import 'shared/data/models/product_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductHiveModelAdapter());
  initDependencies();
  runApp(const ProductCatalogApp());
}

class ProductCatalogApp extends StatefulWidget {
  const ProductCatalogApp({super.key});

  @override
  State<ProductCatalogApp> createState() => _ProductCatalogAppState();
}

class _ProductCatalogAppState extends State<ProductCatalogApp> {
  late final router = AppRouter.router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: MaterialApp.router(
        title: 'Product Catalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }
}
