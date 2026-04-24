import 'package:go_router/go_router.dart';
import '../../features/product_list/presentation/pages/product_list_page.dart';
import '../../features/product_detail/presentation/pages/product_detail_page.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static GoRouter get router => GoRouter(
    initialLocation: AppRoutes.productList,
    routes: [
      GoRoute(path: AppRoutes.productList, builder: (_, __) => const ProductListPage()),
      GoRoute(
        path: '${AppRoutes.productDetailBase}/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailPage(productId: id);
        },
      ),
    ],
  );
}
