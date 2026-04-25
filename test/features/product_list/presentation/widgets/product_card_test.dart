import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test/app_theme.dart';
import 'package:product_catalog_test/features/product_list/presentation/widgets/product_card.dart';
import 'package:product_catalog_test/shared/domain/entities/product_entity.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SizedBox(width: 200, height: 300, child: child)),
);

void main() {
  const tProduct = ProductEntity(
    id: '1',
    name: 'Wireless Headphones Pro',
    sku: 'WHP-001',
    price: 149.99,
    currency: Currency.usd,
    stock: 42,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
  );

  const tOutOfStockProduct = ProductEntity(
    id: '2',
    name: 'Mechanical Keyboard TKL',
    sku: 'MKT-005',
    price: 119.95,
    currency: Currency.usd,
    stock: 0,
    imageUrl: 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?w=600',
  );

  group('ProductCard', () {
    testWidgets('displays product name', (tester) async {
      await tester.pumpWidget(_wrap(ProductCard(product: tProduct, onTap: () {})));

      expect(find.text('Wireless Headphones Pro'), findsOneWidget);
    });

    testWidgets('displays product SKU', (tester) async {
      await tester.pumpWidget(_wrap(ProductCard(product: tProduct, onTap: () {})));

      expect(find.text('SKU: WHP-001'), findsOneWidget);
    });

    testWidgets('displays formatted USD price', (tester) async {
      await tester.pumpWidget(_wrap(ProductCard(product: tProduct, onTap: () {})));

      expect(find.text('\$149.99'), findsOneWidget);
    });

    testWidgets('displays stock count badge for in-stock product', (tester) async {
      await tester.pumpWidget(_wrap(ProductCard(product: tProduct, onTap: () {})));

      expect(find.text('Stock: 42'), findsOneWidget);
    });

    testWidgets('displays "Out of stock" badge for out-of-stock product', (tester) async {
      await tester.pumpWidget(_wrap(ProductCard(product: tOutOfStockProduct, onTap: () {})));

      expect(find.text('Out of stock'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(_wrap(ProductCard(product: tProduct, onTap: () => tapped = true)));

      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows share icon button', (tester) async {
      await tester.pumpWidget(_wrap(ProductCard(product: tProduct, onTap: () {})));

      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('displays BOB price with Bs. prefix', (tester) async {
      const bobProduct = ProductEntity(
        id: '3',
        name: 'BOB Product',
        sku: 'BOB-001',
        price: 350.0,
        currency: Currency.bob,
        stock: 5,
        imageUrl: '',
      );

      await tester.pumpWidget(_wrap(ProductCard(product: bobProduct, onTap: () {})));

      expect(find.text('Bs. 350.00'), findsOneWidget);
    });
  });
}
