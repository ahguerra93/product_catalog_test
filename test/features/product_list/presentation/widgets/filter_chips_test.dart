import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/app_theme.dart';
import 'package:product_catalog_test/features/product_list/presentation/widgets/filter_chips.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('FilterOptionChip', () {
    testWidgets('displays the label', (tester) async {
      await tester.pumpWidget(_wrap(FilterOptionChip(label: 'USD', isSelected: false, onTap: () {})));

      expect(find.text('USD'), findsOneWidget);
    });

    testWidgets('renders as selected FilterChip', (tester) async {
      await tester.pumpWidget(_wrap(FilterOptionChip(label: 'USD', isSelected: true, onTap: () {})));

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, isTrue);
    });

    testWidgets('renders as unselected FilterChip', (tester) async {
      await tester.pumpWidget(_wrap(FilterOptionChip(label: 'USD', isSelected: false, onTap: () {})));

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, isFalse);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(_wrap(FilterOptionChip(label: 'BOB', isSelected: false, onTap: () => tapped = true)));

      await tester.tap(find.byType(FilterChip));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('ClearFilterChip', () {
    testWidgets('displays "Clear" label', (tester) async {
      await tester.pumpWidget(_wrap(ClearFilterChip(onTap: () {})));

      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('shows close icon', (tester) async {
      await tester.pumpWidget(_wrap(ClearFilterChip(onTap: () {})));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(_wrap(ClearFilterChip(onTap: () => tapped = true)));

      await tester.tap(find.byType(FilterChip));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('FilterCategoryHeader', () {
    testWidgets('displays the title', (tester) async {
      await tester.pumpWidget(_wrap(const FilterCategoryHeader(title: 'Currency')));

      expect(find.text('Currency'), findsOneWidget);
    });

    testWidgets('renders inside a Padding widget', (tester) async {
      await tester.pumpWidget(_wrap(const FilterCategoryHeader(title: 'Sort By')));

      expect(find.byType(Padding), findsWidgets);
    });
  });
}
