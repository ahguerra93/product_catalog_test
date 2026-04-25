import '../../../../shared/domain/models/filter_query.dart';

abstract class ProductListEvent {}

class FetchProductsEvent extends ProductListEvent {
  final FilterQuery? filter;
  final bool refresh;

  FetchProductsEvent({this.filter, this.refresh = false});
}

class RefreshProductsEvent extends ProductListEvent {}

class SearchProductsEvent extends ProductListEvent {
  final String query;

  SearchProductsEvent({required this.query});
}

class ApplyFilterEvent extends ProductListEvent {
  final FilterQuery filter;

  ApplyFilterEvent({required this.filter});
}
