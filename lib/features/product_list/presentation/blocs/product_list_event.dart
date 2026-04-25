abstract class ProductListEvent {}

class FetchProductsEvent extends ProductListEvent {
  final String? query;
  final bool refresh;

  FetchProductsEvent({this.query, this.refresh = false});
}

class RefreshProductsEvent extends ProductListEvent {}

class SearchProductsEvent extends ProductListEvent {
  final String query;

  SearchProductsEvent({required this.query});
}
