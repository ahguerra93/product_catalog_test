import 'package:flutter/material.dart';
import 'package:product_catalog_test/app_colors.dart';
import 'package:product_catalog_test/common/app_strings.dart';
import 'package:product_catalog_test/common/app_dimens.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final void Function()? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 72, color: context.colors.error),
            const SizedBox(height: AppDimens.spacingMd),
            Text(AppStrings.somethingWentWrong, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppDimens.spacingXs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: context.colors.textSecondary),
            ),
            if (onRetry != null) ...{
              const SizedBox(height: AppDimens.spacingLg),
              ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: Text(AppStrings.retry)),
            },
          ],
        ),
      ),
    );
  }
}
