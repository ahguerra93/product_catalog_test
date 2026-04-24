abstract final class AppRoutes {
  static const String productList = '/';
  static const String productDetailBase = '/product';

  static String productDetail(String id) => '$productDetailBase/$id';
}
