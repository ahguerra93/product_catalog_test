abstract final class AppRoutes {
  static const String startup = '/';
  static const String productList = '/products';
  static const String productDetailBase = '/product';

  static String productDetail(String id) => '$productDetailBase/$id';
}
