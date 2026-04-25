import 'package:flutter/material.dart';
import 'package:product_catalog_test/shared/presentation/widgets/ripple_effect_widget.dart';
import 'package:product_catalog_test/shared/utils/share_handler.dart';

import '../../../../app_colors.dart';
import '../../../../common/app_dimens.dart';
import '../../../../shared/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,

      child: Stack(
        children: [
          CustomClickable(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: AppDimens.spacingSm,
              children: [
                Flexible(child: _ProductImage(imageUrl: product.imageUrl)),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
                  constraints: BoxConstraints(minHeight: AppDimens.productCardContentHeight),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppDimens.spacingXs,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            'SKU: ${product.sku}',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: context.colors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      Wrap(
                        spacing: AppDimens.spacingSm,
                        children: [
                          Text(
                            product.formattedPrice,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: context.colors.primary),
                          ),
                          _StockBadge(stock: product.stock),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: AppDimens.spacingSm,
            top: AppDimens.spacingSm,
            child: CustomClickable(
              borderRadius: 20,
              onTap: () =>
                  ShareHandler.shareProduct(name: product.name, price: product.formattedPrice, sku: product.sku),
              child: Container(
                decoration: BoxDecoration(color: context.colors.primary, shape: BoxShape.circle),
                padding: EdgeInsets.all(AppDimens.spacingXs),
                child: Icon(Icons.share, size: 24, color: context.colors.textOnPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.productImageHeight,
      width: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: context.colors.surfaceSoft,
          child: Icon(Icons.image_not_supported_outlined, size: 48, color: context.colors.textSecondary),
        ),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: context.colors.surfaceSoft,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.primary)),
          );
        },
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int stock;

  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final inStock = stock > 0;
    final statusColor = inStock ? context.colors.success : context.colors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSm, vertical: AppDimens.spacingXs),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: Text(
        inStock ? 'Stock: $stock' : 'Out of stock',
        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: statusColor),
      ),
    );
  }
}
