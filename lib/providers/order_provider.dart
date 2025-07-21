import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  static const String _ordersKey = 'user_orders';

  List<Order> get orders => [..._orders];
  int get orderCount => _orders.length;
  bool get isEmpty => _orders.isEmpty;

  List<Order> get activeOrders =>
      _orders.where((order) => order.isActive).toList();
  List<Order> get completedOrders =>
      _orders.where((order) => !order.isActive).toList();

  // Load orders from SharedPreferences
  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersData = prefs.getString(_ordersKey);

      if (ordersData != null) {
        final List<dynamic> decodedData = json.decode(ordersData);
        _orders = decodedData.map((order) => Order.fromJson(order)).toList();

        // Sort orders by date (newest first)
        _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error loading orders: $error');
      }
    }
  }

  // Save orders to SharedPreferences
  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersData = json.encode(
        _orders.map((order) => order.toJson()).toList(),
      );
      await prefs.setString(_ordersKey, ordersData);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving orders: $error');
      }
    }
  }

  // Create a new order from cart items
  Future<Order> createOrder({
    required List<CartItem> cartItems,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final orderItems = cartItems
        .map(
          (cartItem) => OrderItem(
            productId: cartItem.productId,
            title: cartItem.title,
            imageUrl: cartItem.imageUrl,
            price: cartItem.price,
            quantity: cartItem.quantity,
          ),
        )
        .toList();

    // Mock shipping address (in a real app, this would come from user input)
    final shippingAddress = ShippingAddress(
      name: 'John Doe',
      street: '123 Main Street',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'United States',
    );

    final order = Order(
      id: orderId,
      orderDate: DateTime.now(),
      items: orderItems,
      totalAmount: totalAmount,
      status: 'pending',
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
    );

    _orders.insert(0, order); // Add to beginning (newest first)
    notifyListeners();
    await _saveOrders();

    // Simulate order status updates
    _simulateOrderProgress(order);

    return order;
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final updatedOrder = Order(
        id: _orders[orderIndex].id,
        orderDate: _orders[orderIndex].orderDate,
        items: _orders[orderIndex].items,
        totalAmount: _orders[orderIndex].totalAmount,
        status: newStatus,
        paymentMethod: _orders[orderIndex].paymentMethod,
        shippingAddress: _orders[orderIndex].shippingAddress,
        deliveryDate: newStatus.toLowerCase() == 'delivered'
            ? DateTime.now()
            : _orders[orderIndex].deliveryDate,
      );

      _orders[orderIndex] = updatedOrder;
      notifyListeners();
      await _saveOrders();
    }
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'cancelled');
  }

  // Clear all orders (for testing purposes)
  Future<void> clearOrders() async {
    _orders.clear();
    notifyListeners();
    await _saveOrders();
  }

  // Simulate order progress (for demo purposes)
  void _simulateOrderProgress(Order order) {
    // After 10 seconds, mark as processing
    Future.delayed(const Duration(seconds: 10), () {
      updateOrderStatus(order.id, 'processing');
    });

    // After 30 seconds, mark as shipped
    Future.delayed(const Duration(seconds: 30), () {
      updateOrderStatus(order.id, 'shipped');
    });

    // After 60 seconds, mark as delivered
    Future.delayed(const Duration(seconds: 60), () {
      updateOrderStatus(order.id, 'delivered');
    });
  }

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get total spent by user
  double get totalSpent {
    return _orders
        .where((order) => order.status.toLowerCase() != 'cancelled')
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Get order statistics
  Map<String, int> get orderStats {
    final stats = <String, int>{};
    for (final order in _orders) {
      stats[order.status] = (stats[order.status] ?? 0) + 1;
    }
    return stats;
  }
}
