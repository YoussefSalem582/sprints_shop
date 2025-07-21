import 'package:flutter_test/flutter_test.dart';
import 'package:sprints_shop/models/product.dart';
import 'package:sprints_shop/providers/wishlist_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WishlistProvider Tests', () {
    late WishlistProvider wishlistProvider;
    late Product testProduct;

    setUp(() {
      wishlistProvider = WishlistProvider();
      testProduct = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test product description',
      );
    });

    test('should start with empty wishlist', () {
      expect(wishlistProvider.items, isEmpty);
      expect(wishlistProvider.itemCount, equals(0));
    });

    test('should add item to wishlist', () {
      wishlistProvider.addItem(testProduct);

      expect(wishlistProvider.items.length, equals(1));
      expect(wishlistProvider.itemCount, equals(1));
      expect(wishlistProvider.items.first.id, equals('1'));
    });

    test('should not add duplicate items to wishlist', () {
      wishlistProvider.addItem(testProduct);
      wishlistProvider.addItem(testProduct);

      expect(wishlistProvider.items.length, equals(1));
      expect(wishlistProvider.itemCount, equals(1));
    });

    test('should remove item from wishlist', () {
      wishlistProvider.addItem(testProduct);
      expect(wishlistProvider.items.length, equals(1));

      wishlistProvider.removeItem(testProduct.id);
      expect(wishlistProvider.items, isEmpty);
      expect(wishlistProvider.itemCount, equals(0));
    });

    test('should toggle item in wishlist', () {
      // Add item
      wishlistProvider.toggleItem(testProduct);
      expect(wishlistProvider.items.length, equals(1));
      expect(wishlistProvider.isInWishlist(testProduct.id), isTrue);

      // Remove item
      wishlistProvider.toggleItem(testProduct);
      expect(wishlistProvider.items, isEmpty);
      expect(wishlistProvider.isInWishlist(testProduct.id), isFalse);
    });

    test('should check if item is favorite', () {
      expect(wishlistProvider.isInWishlist(testProduct.id), isFalse);

      wishlistProvider.addItem(testProduct);
      expect(wishlistProvider.isInWishlist(testProduct.id), isTrue);

      wishlistProvider.removeItem(testProduct.id);
      expect(wishlistProvider.isInWishlist(testProduct.id), isFalse);
    });

    test('should clear entire wishlist', () {
      wishlistProvider.addItem(testProduct);

      final secondProduct = Product(
        id: '2',
        title: 'Second Product',
        price: 19.99,
        imageUrl: 'https://example.com/image2.jpg',
        description: 'Second product description',
      );
      wishlistProvider.addItem(secondProduct);

      expect(wishlistProvider.items.length, equals(2));

      wishlistProvider.clearWishlist();
      expect(wishlistProvider.items, isEmpty);
      expect(wishlistProvider.itemCount, equals(0));
    });

    test('should handle multiple items correctly', () {
      final products = List.generate(
        5,
        (index) => Product(
          id: 'product_$index',
          title: 'Product $index',
          price: 10.0 * (index + 1),
          imageUrl: 'https://example.com/image$index.jpg',
          description: 'Product $index description',
        ),
      );

      // Add all products
      for (final product in products) {
        wishlistProvider.addItem(product);
      }

      expect(wishlistProvider.itemCount, equals(5));

      // Check all are favorites
      for (final product in products) {
        expect(wishlistProvider.isInWishlist(product.id), isTrue);
      }

      // Remove one product
      wishlistProvider.removeItem(products[2].id);
      expect(wishlistProvider.itemCount, equals(4));
      expect(wishlistProvider.isInWishlist(products[2].id), isFalse);

      // Other products should still be favorites
      expect(wishlistProvider.isInWishlist(products[0].id), isTrue);
      expect(wishlistProvider.isInWishlist(products[1].id), isTrue);
      expect(wishlistProvider.isInWishlist(products[3].id), isTrue);
      expect(wishlistProvider.isInWishlist(products[4].id), isTrue);
    });
  });
}
