import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  static const String _cartKey = 'shopping_cart';

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  // Load cart from SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);

      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error loading cart: $error');
      }
    }
  }

  // Save cart to SharedPreferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartData);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving cart: $error');
      }
    }
  }

  // Add item to cart
  void addItem(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Item already exists, increase quantity
      _items[existingIndex].quantity++;
    } else {
      // Add new item
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          productId: product.id,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
    _saveCart();
  }

  // Remove single item from cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
    _saveCart();
  }

  // Remove single quantity of an item
  void removeSingleItem(String productId) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId,
    );

    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
      _saveCart();
    }
  }

  // Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  // Get quantity of specific product in cart
  int getProductQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        id: '',
        productId: '',
        title: '',
        imageUrl: '',
        price: 0,
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}
