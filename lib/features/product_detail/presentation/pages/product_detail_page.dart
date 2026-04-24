import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_colors.dart';
import '../../../../common/app_dimens.dart';
import '../../../../di/di.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../product_list/domain/usecases/get_product_by_id_usecase.dart';
import '../cubits/product_detail_cubit.dart';
import '../cubits/product_detail_state.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailCubit(getProductByIdUseCase: getIt<GetProductByIdUseCase>())..fetchProduct(productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        return switch (state) {
          ProductDetailLoading() => const _LoadingView(),
          ProductDetailSuccess(:final product) => _ContentView(product: product),
          ProductDetailNotFound() => const _NotFoundView(),
          ProductDetailError(:final message) => _ErrorView(message: message),
          _ => const _LoadingView(),
        };
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: context.colors.primary)),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: const Center(child: Text('Product not found.')),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 72, color: context.colors.error),
              const SizedBox(height: AppDimens.spacingMd),
              Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppDimens.spacingLg),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Go Back')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final ProductEntity product;

  const _ContentView({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImageBanner(imageUrl: product.imageUrl),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: _ProductInfoSection(product: product),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImageBanner extends StatelessWidget {
  final String imageUrl;

  const _ProductImageBanner({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimens.productDetailBannerHeight,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: context.colors.primaryContainer,
          child: Icon(Icons.image_not_supported_outlined, size: 64, color: context.colors.textSecondary),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: context.colors.surfaceSoft,
            child: Center(child: CircularProgressIndicator(color: context.colors.primary)),
          );
        },
      ),
    );
  }
}

class _ProductInfoSection extends StatelessWidget {
  final ProductEntity product;

  const _ProductInfoSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppDimens.spacingXs),
        Text(
          'SKU: ${product.sku}',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: AppDimens.spacingLg),
        _InfoRow(label: 'Price', value: product.formattedPrice),
        const SizedBox(height: AppDimens.spacingSm),
        _InfoRow(label: 'Currency', value: product.currencyLabel),
        const SizedBox(height: AppDimens.spacingSm),
        _InfoRow(
          label: 'Stock',
          value: product.stock > 0 ? '${product.stock} units' : 'Out of stock',
          valueColor: product.stock > 0 ? context.colors.success : context.colors.error,
        ),
        const SizedBox(height: AppDimens.spacingXl),
        _StockStatusCard(stock: product.stock),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.colors.textSecondary)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: valueColor ?? context.colors.textPrimary),
        ),
      ],
    );
  }
}

class _StockStatusCard extends StatelessWidget {
  final int stock;

  const _StockStatusCard({required this.stock});

  @override
  Widget build(BuildContext context) {
    final inStock = stock > 0;
    final statusColor = inStock ? context.colors.success : context.colors.error;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(inStock ? Icons.check_circle_outline : Icons.remove_circle_outline, color: statusColor),
          const SizedBox(width: AppDimens.spacingSm),
          Text(
            inStock ? 'Available – ready to ship' : 'Currently unavailable',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: statusColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
