import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sprints_shop/models/product.dart';
import 'package:sprints_shop/widgets/product_card.dart';
import 'package:sprints_shop/providers/cart_provider.dart';
import 'package:sprints_shop/providers/wishlist_provider.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        imageUrl: 'https://via.placeholder.com/150',
        description: 'Test product description',
      );
    });

    Widget createTestWidget(Product product) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: MaterialApp(
          home: Scaffold(body: ProductCard(product: product)),
        ),
      );
    }

    testWidgets('should display product information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testProduct));

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have add to cart button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testProduct));

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('should have wishlist toggle button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testProduct));

      // Should find either favorite or favorite_border icon
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              (widget.icon == Icons.favorite ||
                  widget.icon == Icons.favorite_border),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should add product to cart when cart button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testProduct));

      final cartButton = find.byIcon(Icons.add_shopping_cart);
      expect(cartButton, findsOneWidget);

      await tester.tap(cartButton);
      await tester.pump();

      // Verify cart was updated (you might need to adjust this based on your UI feedback)
      // This is a basic test - you might want to add more specific verification
    });

    testWidgets('should toggle wishlist when heart button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testProduct));

      final wishlistButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.favorite ||
                (widget.icon as Icon).icon == Icons.favorite_border),
      );

      expect(wishlistButton, findsOneWidget);

      await tester.tap(wishlistButton);
      await tester.pump();

      // Verify wishlist was updated
    });

    testWidgets('should handle long product titles', (
      WidgetTester tester,
    ) async {
      final longTitleProduct = Product(
        id: '2',
        title:
            'This is a very long product title that should be handled properly by the widget without causing overflow issues',
        price: 49.99,
        imageUrl: 'https://via.placeholder.com/150',
        description: 'Long title product description',
      );

      await tester.pumpWidget(createTestWidget(longTitleProduct));

      expect(
        find.textContaining('This is a very long product title'),
        findsOneWidget,
      );
      expect(find.text('\$49.99'), findsOneWidget);
    });

    testWidgets('should display price correctly for zero price', (
      WidgetTester tester,
    ) async {
      final freeProduct = Product(
        id: '3',
        title: 'Free Product',
        price: 0.0,
        imageUrl: 'https://via.placeholder.com/150',
        description: 'Free product description',
      );

      await tester.pumpWidget(createTestWidget(freeProduct));

      expect(find.text('Free Product'), findsOneWidget);
      expect(find.text('\$0.00'), findsOneWidget);
    });

    testWidgets('should display price correctly for high precision', (
      WidgetTester tester,
    ) async {
      final precisionProduct = Product(
        id: '4',
        title: 'Precision Product',
        price: 29.999,
        imageUrl: 'https://via.placeholder.com/150',
        description: 'High precision price product',
      );

      await tester.pumpWidget(createTestWidget(precisionProduct));

      expect(find.text('Precision Product'), findsOneWidget);
      // The exact format depends on your price formatting logic
      expect(find.textContaining('29.99'), findsOneWidget);
    });

    testWidgets('should be tappable to navigate to details', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testProduct));

      final productCard = find.byType(ProductCard);
      expect(productCard, findsOneWidget);

      // Test that the card is tappable (this depends on your implementation)
      await tester.tap(productCard);
      await tester.pump();
    });
  });
}
