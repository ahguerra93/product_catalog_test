import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../di/di.dart';
import '../../features/product_list/presentation/pages/product_list_page.dart';
import '../../features/product_detail/presentation/pages/product_detail_page.dart';
import '../../features/startup/presentation/pages/startup_page.dart';
import '../logger_config.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static GoRouter get router => GoRouter(
    initialLocation: AppRoutes.startup,
    routes: [
      GoRoute(path: AppRoutes.startup, builder: (_, __) => const StartupPage()),
      GoRoute(path: AppRoutes.productList, builder: (_, __) => const ProductListPage()),
      GoRoute(
        path: '${AppRoutes.productDetailBase}/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailPage(productId: id);
        },
      ),
    ],
    observers: [_RouteObserver()],
  );
}

class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    getIt<LoggerService>().logRouteNavigation(
      route.settings.name ?? 'unknown',
      params: route.settings.arguments as Map<String, dynamic>?,
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    getIt<LoggerService>().info('⬅️  Popped from: ${route.settings.name ?? "unknown"}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    getIt<LoggerService>().info('🔄 Route replaced: ${oldRoute?.settings.name} → ${newRoute?.settings.name}');
  }
}
