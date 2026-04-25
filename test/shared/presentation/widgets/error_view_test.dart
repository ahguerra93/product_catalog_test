import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/common/app_strings.dart';
import 'package:product_catalog_test/app_theme.dart';
import 'package:product_catalog_test/shared/presentation/widgets/error_view.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('ErrorView', () {
    testWidgets('displays the message', (tester) async {
      await tester.pumpWidget(_wrap(const ErrorView(message: 'Something failed badly')));

      expect(find.text('Something failed badly'), findsOneWidget);
    });

    testWidgets('displays "Something went wrong" title', (tester) async {
      await tester.pumpWidget(_wrap(const ErrorView(message: 'Error detail')));

      expect(find.text(AppStrings.somethingWentWrong), findsOneWidget);
    });

    testWidgets('shows error icon', (tester) async {
      await tester.pumpWidget(_wrap(const ErrorView(message: 'Error')));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('does NOT show Retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(_wrap(const ErrorView(message: 'Error without retry')));

      expect(find.text(AppStrings.retry), findsNothing);
    });

    testWidgets('shows Retry button when onRetry is provided', (tester) async {
      await tester.pumpWidget(_wrap(ErrorView(message: 'Error with retry', onRetry: () {})));

      expect(find.text(AppStrings.retry), findsOneWidget);
    });

    testWidgets('calls onRetry when Retry button is tapped', (tester) async {
      var retryTapped = false;

      await tester.pumpWidget(_wrap(ErrorView(message: 'Tappable error', onRetry: () => retryTapped = true)));

      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();

      expect(retryTapped, isTrue);
    });
  });
}
