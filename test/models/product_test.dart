import 'package:flutter_test/flutter_test.dart';
import 'package:sprints_shop/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('should create product with all properties', () {
      final product = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test product description',
      );

      expect(product.id, equals('1'));
      expect(product.title, equals('Test Product'));
      expect(product.price, equals(29.99));
      expect(product.imageUrl, equals('https://example.com/image.jpg'));
      expect(product.description, equals('Test product description'));
    });

    test('should create product with minimal required properties', () {
      final product = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
      );

      expect(product.id, isNotEmpty);
      expect(product.title, isNotEmpty);
      expect(product.price, greaterThan(0));
      expect(product.imageUrl, isNotEmpty);
      expect(product.description, isNotEmpty);
    });

    test('should handle zero price', () {
      final product = Product(
        id: '1',
        title: 'Free Product',
        price: 0.0,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Free product description',
      );

      expect(product.price, equals(0.0));
    });

    test('should handle long title and description', () {
      const longTitle =
          'This is a very long product title that might be used in some cases where products have detailed names';
      const longDescription =
          'This is a very long product description that contains a lot of details about the product including features, specifications, and other important information that customers might need to know before making a purchase decision.';

      final product = Product(
        id: '1',
        title: longTitle,
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        description: longDescription,
      );

      expect(product.title, equals(longTitle));
      expect(product.description, equals(longDescription));
    });

    test('should handle special characters in strings', () {
      final product = Product(
        id: '1',
        title: 'Product with émojis 🎉 & special chars!',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        description: 'Description with special chars: ñáéíóú & symbols @#\$%',
      );

      expect(product.title, contains('émojis'));
      expect(product.title, contains('🎉'));
      expect(product.description, contains('ñáéíóú'));
      expect(product.description, contains('@#\$%'));
    });

    test('should create multiple products with different properties', () {
      final products = [
        Product(
          id: '1',
          title: 'Product 1',
          price: 10.0,
          imageUrl: 'https://example.com/image1.jpg',
          description: 'Description 1',
        ),
        Product(
          id: '2',
          title: 'Product 2',
          price: 20.0,
          imageUrl: 'https://example.com/image2.jpg',
          description: 'Description 2',
        ),
        Product(
          id: '3',
          title: 'Product 3',
          price: 30.0,
          imageUrl: 'https://example.com/image3.jpg',
          description: 'Description 3',
        ),
      ];

      expect(products.length, equals(3));
      expect(products[0].id, equals('1'));
      expect(products[1].price, equals(20.0));
      expect(products[2].title, equals('Product 3'));
    });

    test('should handle high precision decimal prices', () {
      final product = Product(
        id: '1',
        title: 'Precision Product',
        price: 29.999999,
        imageUrl: 'https://example.com/image.jpg',
        description: 'High precision price product',
      );

      expect(product.price, equals(29.999999));
    });
  });
}
