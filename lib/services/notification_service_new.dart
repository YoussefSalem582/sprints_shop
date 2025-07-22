import 'package:flutter/foundation.dart';
import 'dart:async';

/// Mock notification service for demonstration purposes
/// This service simulates notification functionality without external dependencies
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint('Mock notification service initialized');
    _isInitialized = true;
  }

  /// Show a simple notification (mock implementation)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    debugPrint('Mock notification: $title - $body');
  }

  /// Schedule a notification for later (mock implementation)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? payload,
  }) async {
    debugPrint(
      'Mock scheduled notification for $scheduledDate: $title - $body',
    );
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    debugPrint('Mock notification $id cancelled');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    debugPrint('All mock notifications cancelled');
  }

  /// Get pending notifications
  Future<List<Map<String, dynamic>>> getPendingNotifications() async {
    return []; // Mock empty list
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    debugPrint('Mock notification permissions granted');
    return true;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    return true; // Mock always enabled
  }

  /// Dispose the service
  void dispose() {
    _isInitialized = false;
  }
}
