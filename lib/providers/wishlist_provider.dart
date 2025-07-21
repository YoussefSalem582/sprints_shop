import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _items = [];
  static const String _wishlistKey = 'wishlist_items';

  List<Product> get items => [..._items];

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  // Load wishlist from SharedPreferences
  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistData = prefs.getString(_wishlistKey);

      if (wishlistData != null) {
        final List<dynamic> decodedData = json.decode(wishlistData);
        _items = decodedData
            .map(
              (item) => Product(
                id: item['id'],
                title: item['title'],
                imageUrl: item['imageUrl'],
                price: item['price'].toDouble(),
                description: item['description'],
              ),
            )
            .toList();
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error loading wishlist: $error');
      }
    }
  }

  // Save wishlist to SharedPreferences
  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistData = json.encode(
        _items
            .map(
              (item) => {
                'id': item.id,
                'title': item.title,
                'imageUrl': item.imageUrl,
                'price': item.price,
                'description': item.description,
              },
            )
            .toList(),
      );
      await prefs.setString(_wishlistKey, wishlistData);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving wishlist: $error');
      }
    }
  }

  // Add item to wishlist
  void addItem(Product product) {
    if (!isInWishlist(product.id)) {
      _items.add(product);
      notifyListeners();
      _saveWishlist();
    }
  }

  // Remove item from wishlist
  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
    _saveWishlist();
  }

  // Toggle item in wishlist
  void toggleItem(Product product) {
    if (isInWishlist(product.id)) {
      removeItem(product.id);
    } else {
      addItem(product);
    }
  }

  // Clear entire wishlist
  void clearWishlist() {
    _items.clear();
    notifyListeners();
    _saveWishlist();
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  // Get product from wishlist
  Product? getProduct(String productId) {
    try {
      return _items.firstWhere((item) => item.id == productId);
    } catch (e) {
      return null;
    }
  }
}
