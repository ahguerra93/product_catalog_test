import 'package:flutter/material.dart';
import 'package:product_catalog_test/common/app_strings.dart';
import 'package:product_catalog_test/common/app_durations.dart';
import '../../../../app_colors.dart';
import '../../../../common/app_dimens.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/enums/order_by.dart';
import '../../../../shared/domain/enums/sort_type.dart';
import '../../../../shared/domain/models/filter_query.dart';
import '../../../../shared/domain/models/price_range.dart';
import '../../../../shared/domain/models/sorting.dart';
import 'filter_chips.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterQuery? initialFilter;

  const FilterBottomSheet({super.key, this.initialFilter});

  static Future<FilterQuery?> show(BuildContext context, {FilterQuery? initialFilter}) {
    return showModalBottomSheet<FilterQuery?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => FilterBottomSheet(initialFilter: initialFilter),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterQuery _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? const FilterQuery();
  }

  void _updateStockOnly(bool inStockOnly) {
    setState(() {
      _filter = _filter.copyWith(inStockOnly: inStockOnly);
    });
  }

  void _updateCurrency(Currency? currency) {
    setState(() {
      _filter = _filter.copyWith(currency: currency);
    });
  }

  void _updatePriceRange(PriceRange? priceRange) {
    setState(() {
      _filter = _filter.copyWith(priceRange: priceRange);
    });
  }

  void _updateSortType(SortType sortType) {
    final currentSort = _filter.sorting ?? Sorting.defaultSort();
    setState(() {
      _filter = _filter.copyWith(sorting: currentSort.copyWith(sortType: sortType));
    });
  }

  void _updateOrderBy(OrderBy orderBy) {
    final currentSort = _filter.sorting ?? Sorting.defaultSort();
    setState(() {
      _filter = _filter.copyWith(sorting: currentSort.copyWith(orderBy: orderBy));
    });
  }

  void _clearSorting() {
    setState(() {
      _filter = _filter.copyWith(sorting: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      expand: false,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          _FilterHeader(onClose: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FilterCategoryHeader(title: AppStrings.filtersCategory),
                  _CurrencyFilterSection(selectedCurrency: _filter.currency, onCurrencyChanged: _updateCurrency),
                  _PriceRangeFilterSection(priceRange: _filter.priceRange, onPriceRangeChanged: _updatePriceRange),
                  _StockFilterSection(inStockOnly: _filter.inStockOnly, onStockOnlyChanged: _updateStockOnly),
                  const SizedBox(height: AppDimens.spacingMd),
                  const FilterCategoryHeader(title: AppStrings.orderByCategory),
                  _OrderByFilterSection(
                    sorting: _filter.sorting,
                    onSortTypeChanged: _updateSortType,
                    onOrderByChanged: _updateOrderBy,
                    onClearSorting: _clearSorting,
                  ),
                  const SizedBox(height: AppDimens.spacingLg),
                ],
              ),
            ),
          ),
          _FilterBottomActions(
            onApply: () => Navigator.pop(context, _filter),
            onClearAll: () => Navigator.pop(context, FilterQuery.empty()),
          ),
        ],
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _FilterHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: AppDimens.spacingSm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.filtersTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }
}

class _CurrencyFilterSection extends StatelessWidget {
  final Currency? selectedCurrency;
  final Function(Currency?) onCurrencyChanged;

  const _CurrencyFilterSection({required this.selectedCurrency, required this.onCurrencyChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          child: Wrap(
            spacing: AppDimens.spacingSm,
            runSpacing: AppDimens.spacingSm,
            children: [
              FilterOptionChip(
                label: 'USD',
                isSelected: selectedCurrency == Currency.usd,
                onTap: () {
                  onCurrencyChanged(selectedCurrency == Currency.usd ? null : Currency.usd);
                },
              ),
              FilterOptionChip(
                label: 'BOB',
                isSelected: selectedCurrency == Currency.bob,
                onTap: () {
                  onCurrencyChanged(selectedCurrency == Currency.bob ? null : Currency.bob);
                },
              ),
              if (selectedCurrency != null) ClearFilterChip(onTap: () => onCurrencyChanged(null)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRangeFilterSection extends StatefulWidget {
  final PriceRange? priceRange;
  final Function(PriceRange?) onPriceRangeChanged;

  const _PriceRangeFilterSection({required this.priceRange, required this.onPriceRangeChanged});

  @override
  State<_PriceRangeFilterSection> createState() => _PriceRangeFilterSectionState();
}

class _PriceRangeFilterSectionState extends State<_PriceRangeFilterSection> {
  late double _minPrice;
  late double _maxPrice;

  @override
  void initState() {
    super.initState();
    _minPrice = widget.priceRange?.minPrice ?? 0;
    _maxPrice = widget.priceRange?.maxPrice ?? 500;
  }

  @override
  Widget build(BuildContext context) {
    final hasPrice = widget.priceRange != null && !widget.priceRange!.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FilterCategoryHeader(title: AppStrings.priceRangeCategory),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppDimens.spacingMd,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    duration: AppDurations.animationDuration,
                    opacity: hasPrice ? 1 : 0.5,
                    child: Text(
                      '\$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (hasPrice)
                    ClearFilterChip(
                      onTap: () {
                        widget.onPriceRangeChanged(null);
                      },
                    ),
                ],
              ),
              RangeSlider(
                values: RangeValues(_minPrice, _maxPrice),
                min: 0,
                max: 500,
                divisions: 50,
                labels: RangeLabels('\$${_minPrice.toStringAsFixed(0)}', '\$${_maxPrice.toStringAsFixed(0)}'),
                onChanged: (RangeValues values) {
                  setState(() {
                    _minPrice = values.start;
                    _maxPrice = values.end;
                  });
                  widget.onPriceRangeChanged(PriceRange(minPrice: values.start, maxPrice: values.end));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StockFilterSection extends StatelessWidget {
  final bool inStockOnly;
  final Function(bool) onStockOnlyChanged;

  const _StockFilterSection({required this.inStockOnly, required this.onStockOnlyChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FilterCategoryHeader(title: AppStrings.availabilityCategory),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          child: Wrap(
            spacing: AppDimens.spacingSm,
            runSpacing: AppDimens.spacingSm,
            children: [
              FilterOptionChip(
                label: AppStrings.inStockOnly,
                isSelected: inStockOnly,
                onTap: () {
                  onStockOnlyChanged(!inStockOnly);
                },
              ),
              if (inStockOnly)
                ClearFilterChip(
                  onTap: () {
                    onStockOnlyChanged(false);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderByFilterSection extends StatelessWidget {
  final Sorting? sorting;
  final Function(SortType) onSortTypeChanged;
  final Function(OrderBy) onOrderByChanged;
  final VoidCallback onClearSorting;

  const _OrderByFilterSection({
    required this.sorting,
    required this.onSortTypeChanged,
    required this.onOrderByChanged,
    required this.onClearSorting,
  });

  @override
  Widget build(BuildContext context) {
    final currentSort = sorting ?? Sorting.defaultSort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FilterCategoryHeader(title: AppStrings.sortTypeCategory),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          child: Wrap(
            spacing: AppDimens.spacingSm,
            runSpacing: AppDimens.spacingSm,
            children: [
              FilterOptionChip(
                label: SortType.price.label,
                isSelected: currentSort.sortType == SortType.price,
                onTap: () => onSortTypeChanged(SortType.price),
              ),
              FilterOptionChip(
                label: SortType.name.label,
                isSelected: currentSort.sortType == SortType.name,
                onTap: () => onSortTypeChanged(SortType.name),
              ),
              FilterOptionChip(
                label: SortType.sku.label,
                isSelected: currentSort.sortType == SortType.sku,
                onTap: () => onSortTypeChanged(SortType.sku),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spacingMd),
        const FilterCategoryHeader(title: AppStrings.orderCategory),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          child: Wrap(
            spacing: AppDimens.spacingSm,
            runSpacing: AppDimens.spacingSm,
            children: [
              FilterOptionChip(
                label: OrderBy.asc.label,
                isSelected: currentSort.orderBy == OrderBy.asc,
                onTap: () => onOrderByChanged(OrderBy.asc),
              ),
              FilterOptionChip(
                label: OrderBy.desc.label,
                isSelected: currentSort.orderBy == OrderBy.desc,
                onTap: () => onOrderByChanged(OrderBy.desc),
              ),
              if (sorting != null) ClearFilterChip(onTap: onClearSorting),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterBottomActions extends StatelessWidget {
  final VoidCallback onApply;
  final VoidCallback onClearAll;

  const _FilterBottomActions({required this.onApply, required this.onClearAll});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        spacing: AppDimens.spacingMd,
        children: [
          Expanded(
            child: OutlinedButton(onPressed: onClearAll, child: Text(AppStrings.clearAll)),
          ),
          Expanded(
            child: FilledButton(onPressed: onApply, child: Text(AppStrings.applyFilters)),
          ),
        ],
      ),
    );
  }
}
