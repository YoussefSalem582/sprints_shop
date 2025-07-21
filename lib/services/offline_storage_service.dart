import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class OfflineStorageService {
  static Database? _database;
  static const String _databaseName = 'sprints_shop.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _productsTable = 'products';
  static const String _cartTable = 'cart_items';
  static const String _favoritesTable = 'favorites';
  static const String _cacheTable = 'cache_data';

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing database: $e');
      }
      rethrow;
    }
  }

  // Create database tables
  static Future<void> _onCreate(Database db, int version) async {
    try {
      // Products table
      await db.execute('''
        CREATE TABLE $_productsTable (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          price REAL NOT NULL,
          imageUrl TEXT NOT NULL,
          category TEXT,
          rating REAL DEFAULT 0.0,
          reviewCount INTEGER DEFAULT 0,
          isFeatured INTEGER DEFAULT 0,
          createdAt INTEGER NOT NULL,
          updatedAt INTEGER NOT NULL
        )
      ''');

      // Cart items table
      await db.execute('''
        CREATE TABLE $_cartTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId TEXT NOT NULL,
          title TEXT NOT NULL,
          price REAL NOT NULL,
          imageUrl TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          addedAt INTEGER NOT NULL
        )
      ''');

      // Favorites table
      await db.execute('''
        CREATE TABLE $_favoritesTable (
          productId TEXT PRIMARY KEY,
          addedAt INTEGER NOT NULL
        )
      ''');

      // Cache data table for storing API responses
      await db.execute('''
        CREATE TABLE $_cacheTable (
          key TEXT PRIMARY KEY,
          data TEXT NOT NULL,
          expiresAt INTEGER NOT NULL,
          createdAt INTEGER NOT NULL
        )
      ''');

      if (kDebugMode) {
        print('Database tables created successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating database tables: $e');
      }
      rethrow;
    }
  }

  // Handle database upgrades
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database schema changes here
    if (kDebugMode) {
      print('Database upgraded from version $oldVersion to $newVersion');
    }
  }

  // Products operations
  static Future<void> cacheProducts(List<Product> products) async {
    try {
      final db = await database;
      final batch = db.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final product in products) {
        batch.insert(_productsTable, {
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': '', // Add category field to Product model if needed
          'createdAt': now,
          'updatedAt': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
      if (kDebugMode) {
        print('Cached ${products.length} products offline');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error caching products: $e');
      }
    }
  }

  static Future<List<Product>> getCachedProducts() async {
    try {
      final db = await database;
      final maps = await db.query(_productsTable, orderBy: 'updatedAt DESC');

      return maps
          .map(
            (map) => Product(
              id: map['id'] as String,
              title: map['title'] as String,
              description: map['description'] as String,
              price: map['price'] as double,
              imageUrl: map['imageUrl'] as String,
            ),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cached products: $e');
      }
      return [];
    }
  }

  // Cart operations
  static Future<void> saveCartOffline(List<CartItem> cartItems) async {
    try {
      final db = await database;

      // Clear existing cart items
      await db.delete(_cartTable);

      if (cartItems.isEmpty) return;

      final batch = db.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final item in cartItems) {
        batch.insert(_cartTable, {
          'productId': item.productId,
          'title': item.title,
          'price': item.price,
          'imageUrl': item.imageUrl,
          'quantity': item.quantity,
          'addedAt': now,
        });
      }

      await batch.commit();
      if (kDebugMode) {
        print('Saved ${cartItems.length} cart items offline');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving cart offline: $e');
      }
    }
  }

  static Future<List<CartItem>> getOfflineCart() async {
    try {
      final db = await database;
      final maps = await db.query(_cartTable, orderBy: 'addedAt DESC');

      return maps
          .map(
            (map) => CartItem(
              id: '${map['productId']}_${map['addedAt']}', // Generate unique ID
              productId: map['productId'] as String,
              title: map['title'] as String,
              price: map['price'] as double,
              imageUrl: map['imageUrl'] as String,
              quantity: map['quantity'] as int,
            ),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting offline cart: $e');
      }
      return [];
    }
  }

  // Favorites operations
  static Future<void> addToFavoritesOffline(String productId) async {
    try {
      final db = await database;
      await db.insert(_favoritesTable, {
        'productId': productId,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to favorites offline: $e');
      }
    }
  }

  static Future<void> removeFromFavoritesOffline(String productId) async {
    try {
      final db = await database;
      await db.delete(
        _favoritesTable,
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error removing from favorites offline: $e');
      }
    }
  }

  static Future<List<String>> getOfflineFavorites() async {
    try {
      final db = await database;
      final maps = await db.query(_favoritesTable, orderBy: 'addedAt DESC');

      return maps.map((map) => map['productId'] as String).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting offline favorites: $e');
      }
      return [];
    }
  }

  // Generic cache operations
  static Future<void> cacheData(
    String key,
    Map<String, dynamic> data, {
    Duration? expiry,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiresAt = expiry != null
          ? now + expiry.inMilliseconds
          : now + const Duration(days: 7).inMilliseconds;

      await db.insert(_cacheTable, {
        'key': key,
        'data': json.encode(data),
        'expiresAt': expiresAt,
        'createdAt': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      if (kDebugMode) {
        print('Error caching data: $e');
      }
    }
  }

  static Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final db = await database;
      final maps = await db.query(
        _cacheTable,
        where: 'key = ? AND expiresAt > ?',
        whereArgs: [key, DateTime.now().millisecondsSinceEpoch],
      );

      if (maps.isNotEmpty) {
        return json.decode(maps.first['data'] as String);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cached data: $e');
      }
      return null;
    }
  }

  // Cleanup operations
  static Future<void> clearExpiredCache() async {
    try {
      final db = await database;
      final deletedCount = await db.delete(
        _cacheTable,
        where: 'expiresAt < ?',
        whereArgs: [DateTime.now().millisecondsSinceEpoch],
      );

      if (kDebugMode) {
        print('Cleared $deletedCount expired cache entries');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing expired cache: $e');
      }
    }
  }

  static Future<void> clearAllCache() async {
    try {
      final db = await database;
      await db.delete(_cacheTable);
      if (kDebugMode) {
        print('Cleared all cache data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing all cache: $e');
      }
    }
  }

  // Database maintenance
  static Future<void> compactDatabase() async {
    try {
      final db = await database;
      await db.execute('VACUUM');
      if (kDebugMode) {
        print('Database compacted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error compacting database: $e');
      }
    }
  }

  // Get database size and statistics
  static Future<Map<String, int>> getDatabaseStats() async {
    try {
      final db = await database;

      final productCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $_productsTable'),
          ) ??
          0;

      final cartCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $_cartTable'),
          ) ??
          0;

      final favoritesCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $_favoritesTable'),
          ) ??
          0;

      final cacheCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $_cacheTable'),
          ) ??
          0;

      return {
        'products': productCount,
        'cart': cartCount,
        'favorites': favoritesCount,
        'cache': cacheCount,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting database stats: $e');
      }
      return {};
    }
  }
}
