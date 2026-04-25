import 'package:flutter/material.dart';
import '../../../../app_colors.dart';
import '../../../../common/app_dimens.dart';

/// Reusable filter chip for displaying filter options
class FilterOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showCheckmark;

  const FilterOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showCheckmark = true,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: context.colors.surface,
      selectedColor: context.colors.primary.withValues(alpha: 0.2),
      side: BorderSide(color: isSelected ? context.colors.primary : context.colors.border, width: isSelected ? 2 : 1),
      labelStyle: TextStyle(
        color: isSelected ? context.colors.primary : context.colors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      showCheckmark: showCheckmark && isSelected,
      checkmarkColor: context.colors.primary,
    );
  }
}

/// Clear button chip for resetting filter category
class ClearFilterChip extends StatelessWidget {
  final VoidCallback onTap;

  const ClearFilterChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppDimens.spacingXs,
        children: [
          Icon(Icons.close, size: 16, color: context.colors.error),
          Text('Clear', style: TextStyle(color: context.colors.error)),
        ],
      ),
      onSelected: (_) => onTap(),
      backgroundColor: context.colors.error.withValues(alpha: 0.1),
      side: BorderSide(color: context.colors.error.withValues(alpha: 0.3)),
    );
  }
}

/// Filter category header
class FilterCategoryHeader extends StatelessWidget {
  final String title;

  const FilterCategoryHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.spacingMd,
        right: AppDimens.spacingMd,
        top: AppDimens.spacingMd,
        bottom: AppDimens.spacingSm,
      ),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}
