import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog_test/shared/presentation/widgets/error_view.dart';
import '../../../../app_colors.dart';

import '../../../../common/app_dimens.dart';
import '../../../../di/di.dart';
import '../../../../features/settings/presentation/cubits/settings_cubit.dart';
import '../../../../features/settings/presentation/cubits/settings_state.dart';
import '../../../../features/settings/presentation/widgets/settings_drawer.dart';
import '../../../../config/routing/app_routes.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/datasources/product_datasource.dart';
import '../cubits/product_list_cubit.dart';
import '../cubits/product_list_state.dart';
import '../widgets/product_card.dart';

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
          create: (_) => ProductListCubit(getProductsUseCase: getIt<GetProductsUseCase>())..fetchProducts(),
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

  @override
  void dispose() {
    _searchController.dispose();
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
          _SearchBar(controller: _searchController),
          Expanded(
            child: BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, state) {
                return switch (state) {
                  ProductListInitial() || ProductListLoading() => const _LoadingView(),
                  ProductListRefreshing(:final cachedData) => _GridView(products: cachedData, isRefreshing: true),
                  ProductListSuccess(:final filteredProducts) => _GridView(products: filteredProducts),
                  ProductListEmpty() => const _EmptyView(),
                  ProductListError(:final message) => ErrorView(
                    message: message,
                    onRetry: () => context.read<ProductListCubit>().fetchProducts(),
                  ),
                  _ => const _LoadingView(),
                };
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

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.primary,
      padding: const EdgeInsets.fromLTRB(AppDimens.spacingMd, 0, AppDimens.spacingMd, AppDimens.spacingMd),
      child: TextField(
        controller: controller,
        onChanged: (query) => context.read<ProductListCubit>().search(query),
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
                  context.read<ProductListCubit>().search('');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List products;
  final bool isRefreshing;

  const _GridView({required this.products, this.isRefreshing = false});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () async {
        context.read<ProductListCubit>().refresh();
        // await context.read<ProductListCubit>().stream.firstWhere((s) => s is! ProductListRefreshing);
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: isRefreshing ? 0 : 300),
        opacity: isRefreshing ? 0.6 : 1,
        child: GridView.builder(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppDimens.spacingMd,
            mainAxisSpacing: AppDimens.spacingMd,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () async {
                await context.push(AppRoutes.productDetail(product.id));
                if (context.mounted) {
                  context.read<ProductListCubit>().refresh();
                }
              },
            );
          },
        ),
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
