import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/app_theme.dart';
import 'package:product_catalog_test/shared/presentation/widgets/ripple_effect_widget.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('CustomClickable', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(_wrap(const CustomClickable(child: Text('Click me'))));

      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _wrap(
          CustomClickable(
            onTap: () => tapped = true,
            child: const SizedBox(width: 100, height: 100, child: Text('Tap target')),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not throw when onTap is null', (tester) async {
      await tester.pumpWidget(_wrap(const CustomClickable(child: SizedBox(width: 100, height: 100))));

      await tester.tap(find.byType(InkWell));
      await tester.pump();
      // no exception
    });

    testWidgets('applies borderRadius when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const CustomClickable(borderRadius: 12.0, child: SizedBox(width: 100, height: 100))),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.borderRadius, equals(BorderRadius.circular(12.0)));
    });

    testWidgets('InkWell borderRadius is null when borderRadius not provided', (tester) async {
      await tester.pumpWidget(_wrap(const CustomClickable(child: SizedBox(width: 100, height: 100))));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.borderRadius, isNull);
    });
  });
}
