import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog_test/features/product_list/presentation/widgets/filter_bottom_sheet.dart';
import 'package:product_catalog_test/shared/data/datasources/product_datasource.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';
import 'package:product_catalog_test/shared/domain/models/filter_query.dart';
import 'package:product_catalog_test/shared/presentation/widgets/error_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../app_colors.dart';

import '../../../../common/app_dimens.dart';
import '../../../../common/app_durations.dart';
import '../../../../di/di.dart';
import '../../../../features/settings/presentation/cubits/settings_cubit.dart';
import '../../../../features/settings/presentation/cubits/settings_state.dart';
import '../../../../features/settings/presentation/widgets/settings_drawer.dart';
import '../../../../config/routing/app_routes.dart';
import '../blocs/product_list_bloc.dart';
import '../blocs/product_list_event.dart';
import '../blocs/product_list_state.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_chips.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        // Update the datasource simulation mode when settings change
        final dataSource = getIt<ProductMockDataSource>();
        dataSource.simulationMode = settingsState.simulationMode;

        return BlocProvider(
          key: ValueKey(settingsState.simulationMode),
          create: (_) => getIt<ProductListBloc>()..add(FetchProductsEvent()),
          child: const _ProductListView(),
        );
      },
    );
  }
}

class _ProductListView extends StatefulWidget {
  const _ProductListView();

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  FilterQuery? _currentFilter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if we've scrolled to 80% of max scroll extent
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ProductListBloc>().add(LoadMoreProductsEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Settings',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: BlocProvider.value(value: getIt<SettingsCubit>(), child: const SettingsDrawer()),
      body: Column(
        children: [
          _SearchBar(
            controller: _searchController,
            currentFilter: _currentFilter,
            onFilterChanged: (filter) {
              setState(() {
                _currentFilter = filter;
              });
              context.read<ProductListBloc>().add(ApplyFilterEvent(filter: filter));
            },
          ),
          _ActiveFiltersChips(
            filter: _currentFilter,
            onClear: () {
              setState(() {
                _currentFilter = null;
              });
              context.read<ProductListBloc>().add(ApplyFilterEvent(filter: FilterQuery.empty()));
            },
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                // Update the current filter from the state
                if (state is ProductListSuccess || state is ProductListLoadingMore || state is ProductListNoMore) {
                  if (state is ProductListSuccess) {
                    _currentFilter = state.currentFilter;
                  } else if (state is ProductListLoadingMore) {
                    _currentFilter = state.currentFilter;
                  } else if (state is ProductListNoMore) {
                    _currentFilter = state.currentFilter;
                  }
                }
                return AnimatedSwitcher(
                  duration: AppDurations.animationDuration,
                  child: switch (state) {
                    ProductListLoading() => const _LoadingView(),
                    ProductListSuccess(:final products) => _GridView(
                      products: products,
                      scrollController: _scrollController,
                    ),
                    ProductListLoadingMore(:final products) => _GridView(
                      products: products,
                      scrollController: _scrollController,
                      isLoadingMore: true,
                    ),
                    ProductListNoMore(:final products) => _GridView(
                      products: products,
                      scrollController: _scrollController,
                      isEndOfList: true,
                    ),
                    ProductListEmpty() => const _EmptyView(),
                    ProductListError(:final message) => ErrorView(
                      message: message,
                      onRetry: () => context.read<ProductListBloc>().add(FetchProductsEvent()),
                    ),
                    _ => const _LoadingView(),
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FilterQuery? currentFilter;
  final Function(FilterQuery) onFilterChanged;

  const _SearchBar({required this.controller, required this.currentFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = currentFilter?.hasActiveFilters ?? false;

    return Container(
      color: context.colors.primary,
      padding: const EdgeInsets.fromLTRB(AppDimens.spacingMd, 0, AppDimens.spacingSm, AppDimens.spacingMd),
      child: Row(
        spacing: AppDimens.spacingSm,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (query) => context.read<ProductListBloc>().add(SearchProductsEvent(query: query)),
              decoration: InputDecoration(
                hintText: 'Search by name or SKU…',
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.colors.textSecondary),
                prefixIcon: Icon(Icons.search, color: context.colors.textSecondary),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(Icons.clear, color: context.colors.textSecondary),
                      onPressed: () {
                        controller.clear();
                        context.read<ProductListBloc>().add(SearchProductsEvent(query: ''));
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: hasActiveFilters ? context.colors.background : context.colors.surfaceSoft,
                ),
                tooltip: 'Filters',
                onPressed: () async {
                  final filter = await FilterBottomSheet.show(context, initialFilter: currentFilter);
                  if (filter != null) {
                    onFilterChanged(filter.copyWith(query: controller.text.isEmpty ? null : controller.text));
                  }
                },
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: context.colors.error, shape: BoxShape.circle),
                    child: Text(
                      '•',
                      style: TextStyle(color: context.colors.textOnPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List products;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool isEndOfList;

  const _GridView({
    required this.products,
    required this.scrollController,
    this.isLoadingMore = false,
    this.isEndOfList = false,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () async {
        context.read<ProductListBloc>().add(RefreshProductsEvent());
      },
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimens.spacingMd,
          mainAxisSpacing: AppDimens.spacingMd,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (isLoadingMore && index == products.length) {
            return Skeletonizer(child: ProductCard(product: ProductEntity.empty(), onTap: null));
          }

          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () async {
              await context.push(AppRoutes.productDetail(product.id));
              if (context.mounted) {
                context.read<ProductListBloc>().add(FetchProductsEvent());
              }
            },
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: context.colors.primary));
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 72, color: context.colors.textSecondary),
          const SizedBox(height: AppDimens.spacingMd),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: context.colors.textSecondary),
          ),
          const SizedBox(height: AppDimens.spacingXs),
          Text(
            'Try changing the simulation mode in settings.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ActiveFiltersChips extends StatelessWidget {
  final FilterQuery? filter;
  final VoidCallback onClear;

  const _ActiveFiltersChips({required this.filter, required this.onClear});

  @override
  Widget build(BuildContext context) {
    if (filter == null || !filter!.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return Container(
      color: context.colors.surface,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: AppDimens.spacingSm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: AppDimens.spacingSm,
          children: [
            // Currency chip
            if (filter!.currency != null)
              FilterOptionChip(
                label: filter!.currency!.name.toUpperCase(),
                isSelected: true,
                onTap: () {},
                showCheckmark: false,
              ),
            // Price range chip
            if (filter!.priceRange != null && !filter!.priceRange!.isEmpty)
              FilterOptionChip(
                label:
                    '\$${filter!.priceRange!.minPrice?.toStringAsFixed(0) ?? '0'} - \$${filter!.priceRange!.maxPrice?.toStringAsFixed(0) ?? '∞'}',
                isSelected: true,
                onTap: () {},
                showCheckmark: false,
              ),
            // In Stock chip
            if (filter!.inStockOnly)
              FilterOptionChip(label: 'In Stock', isSelected: true, onTap: () {}, showCheckmark: false),
            // Sorting chip
            if (filter!.sorting != null)
              FilterOptionChip(
                label: '${filter!.sorting!.sortType.label} (${filter!.sorting!.orderBy.label})',
                isSelected: true,
                onTap: () {},
                showCheckmark: false,
              ),
            // Clear button
            ClearFilterChip(onTap: onClear),
          ],
        ),
      ),
    );
  }
}
