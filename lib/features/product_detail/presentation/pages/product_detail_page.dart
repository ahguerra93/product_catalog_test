import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_colors.dart';
import '../../../../common/app_dimens.dart';
import '../../../../common/app_durations.dart';
import '../../../../di/di.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/utils/share_handler.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../cubits/product_detail_cubit.dart';
import '../cubits/product_detail_state.dart';
import '../cubits/update_product_detail_cubit.dart';
import '../cubits/update_product_detail_state.dart';

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
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is ProductDetailSuccess ? state.product.name : '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            ),
            actions: [
              if (state is ProductDetailSuccess)
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () => ShareHandler.shareProduct(
                    name: state.product.name,
                    price: state.product.formattedPrice,
                    sku: state.product.sku,
                  ),
                  tooltip: 'Share product',
                ),
            ],
          ),
          body: Container(
            color: context.colors.background,
            child: AnimatedSwitcher(
              duration: AppDurations.animationDuration,
              child: switch (state) {
                ProductDetailLoading() => const _LoadingView(),
                ProductDetailSuccess(:final product) => _ContentView(product: product),
                ProductDetailNotFound() => const _NotFoundView(),
                ProductDetailError(:final message) => _ErrorView(message: message),
                _ => const _LoadingView(),
              },
            ),
          ),
        );
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
    return BlocProvider(
      create: (_) =>
          UpdateProductDetailCubit(updateProductUseCase: getIt<UpdateProductUseCase>(), initialProduct: product),
      child: BlocListener<UpdateProductDetailCubit, UpdateProductDetailState>(
        listener: (context, state) {
          if (state is UpdateProductDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colors.error,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is UpdateProductDetailSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Product updated successfully'),
                backgroundColor: context.colors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: _UpdateProductView(product: product),
      ),
    );
  }
}

class _UpdateProductView extends StatefulWidget {
  final ProductEntity product;

  const _UpdateProductView({required this.product});

  @override
  State<_UpdateProductView> createState() => _UpdateProductViewState();
}

class _UpdateProductViewState extends State<_UpdateProductView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImageBanner(imageUrl: widget.product.imageUrl),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: Form(
                key: _formKey,
                child: _ProductInfoSection(product: widget.product),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _UpdateButtonBar(
        product: widget.product,
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            context.read<UpdateProductDetailCubit>().submitUpdate();
          }
        },
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

class _ProductInfoSection extends StatefulWidget {
  final ProductEntity product;

  const _ProductInfoSection({required this.product});

  @override
  State<_ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<_ProductInfoSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProductDetailCubit, UpdateProductDetailState>(
      builder: (context, state) {
        if (state is! UpdateProductDetailLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppDimens.spacingXs),
            Text(
              'SKU: ${widget.product.sku}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: context.colors.textSecondary),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _EditablePriceField(
              priceInput: state.priceInput,
              onChanged: (value) => context.read<UpdateProductDetailCubit>().updatePrice(value),
              isLoading: state.isLoading,
            ),
            const SizedBox(height: AppDimens.spacingSm),
            _CurrencyDropdown(
              selectedCurrency: state.currency,
              onChanged: (currency) => context.read<UpdateProductDetailCubit>().updateCurrency(currency),
              isLoading: state.isLoading,
            ),
            const SizedBox(height: AppDimens.spacingSm),
            _InfoRow(
              label: 'Stock',
              value: widget.product.stock > 0 ? '${widget.product.stock} units' : 'Out of stock',
              valueColor: widget.product.stock > 0 ? context.colors.success : context.colors.error,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            _StockStatusCard(stock: widget.product.stock),
          ],
        );
      },
    );
  }
}

class _EditablePriceField extends StatefulWidget {
  final String priceInput;
  final Function(String) onChanged;
  final bool isLoading;

  const _EditablePriceField({required this.priceInput, required this.onChanged, required this.isLoading});

  @override
  State<_EditablePriceField> createState() => _EditablePriceFieldState();
}

class _EditablePriceFieldState extends State<_EditablePriceField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.priceInput);
  }

  @override
  void didUpdateWidget(_EditablePriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.priceInput != widget.priceInput) {
      _controller.text = widget.priceInput;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Price', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: AppDimens.spacingSm),
        TextFormField(
          controller: _controller,
          enabled: !widget.isLoading,
          onChanged: widget.onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.radiusMd)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: AppDimens.spacingSm),
          ),
          validator: (value) {
            final price = double.tryParse(value ?? '');
            if (price == null || price <= 0) {
              return 'Price must be greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final Currency selectedCurrency;
  final Function(Currency) onChanged;
  final bool isLoading;

  const _CurrencyDropdown({required this.selectedCurrency, required this.onChanged, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Currency', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: AppDimens.spacingSm),
        DropdownButtonFormField<Currency>(
          initialValue: selectedCurrency,
          onChanged: isLoading
              ? null
              : (Currency? currency) {
                  if (currency != null) onChanged(currency);
                },
          items: Currency.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.radiusMd)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: AppDimens.spacingSm),
          ),
          validator: (value) {
            if (value == null) {
              return 'Please select a currency';
            }
            return null;
          },
        ),
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

class _UpdateButtonBar extends StatelessWidget {
  final ProductEntity product;

  final void Function()? onPressed;

  const _UpdateButtonBar({this.onPressed, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProductDetailCubit, UpdateProductDetailState>(
      builder: (context, state) {
        if (state is! UpdateProductDetailLoaded) {
          return const SizedBox.shrink();
        }

        final isDisabled = state.isLoading || !state.hasChanges;

        return Container(
          padding: EdgeInsets.only(
            left: AppDimens.spacingMd,
            right: AppDimens.spacingMd,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppDimens.spacingMd,
            top: AppDimens.spacingMd,
          ),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.colors.border)),
          ),
          child: FilledButton(
            onPressed: isDisabled ? null : onPressed,
            child: state.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(context.colors.textOnPrimary),
                    ),
                  )
                : const Text('Update Product'),
          ),
        );
      },
    );
  }
}
