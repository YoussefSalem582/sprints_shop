import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Handle notification tap events
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Request notification permissions (especially for iOS)
  static Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final bool? result = await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? result = await androidImplementation
          ?.requestNotificationsPermission();
      return result ?? false;
    }

    return true;
  }

  /// Show a simple notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'sprints_shop_channel',
          'Sprints Shop Notifications',
          channelDescription: 'Notifications for Sprints Shop app',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Show order status notification
  static Future<void> showOrderNotification({
    required String orderId,
    required String status,
  }) async {
    String title = 'Order Update';
    String body = 'Your order #$orderId is now $status';

    switch (status.toLowerCase()) {
      case 'confirmed':
        title = 'Order Confirmed! 🎉';
        body = 'Your order #$orderId has been confirmed and is being prepared.';
        break;
      case 'shipped':
        title = 'Order Shipped! 📦';
        body = 'Your order #$orderId has been shipped and is on its way!';
        break;
      case 'delivered':
        title = 'Order Delivered! ✅';
        body = 'Your order #$orderId has been delivered. Enjoy your purchase!';
        break;
      case 'cancelled':
        title = 'Order Cancelled ❌';
        body =
            'Your order #$orderId has been cancelled. Refund will be processed.';
        break;
    }

    await showNotification(
      id: orderId.hashCode,
      title: title,
      body: body,
      payload: 'order:$orderId',
    );
  }

  /// Show promotional notification
  static Future<void> showPromotionalNotification({
    required String title,
    required String message,
    String? productId,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: message,
      payload: productId != null ? 'product:$productId' : null,
    );
  }

  /// Show cart abandonment notification
  static Future<void> showCartAbandonmentNotification({
    required int itemCount,
  }) async {
    await showNotification(
      id: 999,
      title: 'Don\'t forget your cart! 🛒',
      body:
          'You have $itemCount items waiting for you. Complete your purchase now!',
      payload: 'cart_abandonment',
    );
  }

  /// Schedule a notification for later
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'sprints_shop_scheduled',
          'Sprints Shop Scheduled',
          channelDescription: 'Scheduled notifications for Sprints Shop',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // iOS doesn't have a direct way to check this
  }
}
