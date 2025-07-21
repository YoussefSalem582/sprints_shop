import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  static const String _notificationsKey = 'app_notifications';

  List<AppNotification> get notifications => [..._notifications];
  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;
  bool get hasUnread => unreadCount > 0;

  // Load notifications from SharedPreferences
  Future<void> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsData = prefs.getString(_notificationsKey);

      if (notificationsData != null) {
        final List<dynamic> decodedData = json.decode(notificationsData);
        _notifications = decodedData
            .map((item) => AppNotification.fromJson(item))
            .toList();

        // Sort by timestamp (newest first)
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error loading notifications: $error');
      }
    }
  }

  // Save notifications to SharedPreferences
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsData = json.encode(
        _notifications.map((notification) => notification.toJson()).toList(),
      );
      await prefs.setString(_notificationsKey, notificationsData);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving notifications: $error');
      }
    }
  }

  // Add a new notification
  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    final notification = AppNotification(
      id: _generateId(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      data: data,
    );

    _notifications.insert(0, notification); // Add to beginning (newest first)
    notifyListeners();
    await _saveNotifications();
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
      await _saveNotifications();
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
    await _saveNotifications();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
    await _saveNotifications();
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    _notifications.clear();
    notifyListeners();
    await _saveNotifications();
  }

  // Get notifications by type
  List<AppNotification> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Generate unique ID
  String _generateId() {
    return 'notif_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  // Simulated push notifications for demo purposes
  Future<void> simulateWelcomeNotifications() async {
    await Future.delayed(const Duration(seconds: 2));
    await addNotification(
      title: '🎉 Welcome to Sprints Shop!',
      message: 'Discover amazing products and great deals. Start shopping now!',
      type: NotificationType.general,
    );

    await Future.delayed(const Duration(seconds: 5));
    await addNotification(
      title: '🔥 Special Offer!',
      message: 'Get 20% off on all electronics. Limited time offer!',
      type: NotificationType.offer,
      data: {'discount': 20, 'category': 'electronics'},
    );
  }

  // Order status notifications
  Future<void> sendOrderNotification({
    required String orderId,
    required String status,
    String? customMessage,
  }) async {
    String title;
    String message;

    switch (status.toLowerCase()) {
      case 'pending':
        title = '📦 Order Confirmed';
        message =
            customMessage ??
            'Your order #${orderId.substring(4, 10)} has been confirmed and is being processed.';
        break;
      case 'processing':
        title = '⚙️ Order Processing';
        message =
            customMessage ??
            'Your order #${orderId.substring(4, 10)} is being prepared for shipment.';
        break;
      case 'shipped':
        title = '🚚 Order Shipped';
        message =
            customMessage ??
            'Your order #${orderId.substring(4, 10)} has been shipped and is on its way!';
        break;
      case 'delivered':
        title = '✅ Order Delivered';
        message =
            customMessage ??
            'Your order #${orderId.substring(4, 10)} has been delivered successfully.';
        break;
      case 'cancelled':
        title = '❌ Order Cancelled';
        message =
            customMessage ??
            'Your order #${orderId.substring(4, 10)} has been cancelled.';
        break;
      default:
        title = '📦 Order Update';
        message =
            customMessage ??
            'Your order #${orderId.substring(4, 10)} status has been updated.';
    }

    await addNotification(
      title: title,
      message: message,
      type: NotificationType.order,
      data: {'orderId': orderId, 'status': status},
    );
  }

  // Payment notifications
  Future<void> sendPaymentNotification({
    required String orderId,
    required double amount,
    required String paymentMethod,
    bool isSuccess = true,
  }) async {
    if (isSuccess) {
      await addNotification(
        title: '💳 Payment Successful',
        message:
            'Payment of \$${amount.toStringAsFixed(2)} via $paymentMethod was successful for order #${orderId.substring(4, 10)}.',
        type: NotificationType.payment,
        data: {
          'orderId': orderId,
          'amount': amount,
          'paymentMethod': paymentMethod,
        },
      );
    } else {
      await addNotification(
        title: '❌ Payment Failed',
        message:
            'Payment of \$${amount.toStringAsFixed(2)} via $paymentMethod failed for order #${orderId.substring(4, 10)}. Please try again.',
        type: NotificationType.payment,
        data: {
          'orderId': orderId,
          'amount': amount,
          'paymentMethod': paymentMethod,
        },
      );
    }
  }

  // Offer notifications
  Future<void> sendOfferNotification({
    required String title,
    required String message,
    Map<String, dynamic>? offerData,
  }) async {
    await addNotification(
      title: title,
      message: message,
      type: NotificationType.offer,
      data: offerData,
    );
  }

  // Native notification support
  bool _nativeNotificationsInitialized = false;
  bool _hasNativePermission = false;

  bool get nativeNotificationsInitialized => _nativeNotificationsInitialized;
  bool get hasNativePermission => _hasNativePermission;

  /// Initialize native notification service
  Future<void> initializeNativeNotifications() async {
    try {
      await NotificationService.initialize();
      _nativeNotificationsInitialized = true;

      // Request permissions
      _hasNativePermission = await NotificationService.requestPermissions();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize native notifications: $e');
      }
    }
  }

  /// Send native notification along with in-app notification
  Future<void> addNotificationWithNative({
    required String title,
    required String message,
    NotificationType type = NotificationType.general,
    Map<String, dynamic>? data,
    bool sendNative = true,
  }) async {
    // Add to in-app notifications
    await addNotification(
      title: title,
      message: message,
      type: type,
      data: data,
    );

    // Send native notification if enabled and permitted
    if (sendNative && _hasNativePermission) {
      await NotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: message,
        payload: data != null ? json.encode(data) : null,
      );
    }
  }

  /// Send native order notification
  Future<void> sendNativeOrderNotification(
    String orderId,
    String status,
  ) async {
    if (_hasNativePermission) {
      await NotificationService.showOrderNotification(
        orderId: orderId,
        status: status,
      );
    }
  }

  /// Send native promotional notification
  Future<void> sendNativePromotionalNotification(
    String title,
    String message,
  ) async {
    if (_hasNativePermission) {
      await NotificationService.showPromotionalNotification(
        title: title,
        message: message,
      );
    }
  }

  /// Get native notification status
  Future<Map<String, dynamic>> getNativeNotificationStatus() async {
    if (!_nativeNotificationsInitialized) {
      return {
        'isInitialized': false,
        'hasPermission': false,
        'isEnabled': false,
        'pendingCount': 0,
      };
    }

    final isEnabled = await NotificationService.areNotificationsEnabled();
    final pendingNotifications =
        await NotificationService.getPendingNotifications();

    return {
      'isInitialized': _nativeNotificationsInitialized,
      'hasPermission': _hasNativePermission,
      'isEnabled': isEnabled,
      'pendingCount': pendingNotifications.length,
    };
  }

  /// Request native notification permissions
  Future<void> requestNativePermissions() async {
    _hasNativePermission = await NotificationService.requestPermissions();
    notifyListeners();
  }
}
