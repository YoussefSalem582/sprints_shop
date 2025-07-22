import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Analytics service for tracking user behavior and app performance
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  static const String _eventsKey = 'analytics_events';
  static const String _sessionKey = 'analytics_session';
  static const String _userPropertiesKey = 'user_properties';

  String? _sessionId;
  DateTime? _sessionStartTime;
  final List<Map<String, dynamic>> _eventQueue = [];

  /// Initialize analytics service
  Future<void> initialize() async {
    await _startNewSession();
    await _loadQueuedEvents();
    debugPrint('Analytics service initialized');
  }

  /// Start a new analytics session
  Future<void> _startNewSession() async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _sessionStartTime = DateTime.now();

    await _saveSessionData();
    await trackEvent('session_start', {
      'session_id': _sessionId,
      'platform': defaultTargetPlatform.name,
      'timestamp': _sessionStartTime!.toIso8601String(),
    });
  }

  /// End the current session
  Future<void> endSession() async {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      await trackEvent('session_end', {
        'session_id': _sessionId,
        'duration_seconds': sessionDuration.inSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Track a custom event
  Future<void> trackEvent(
    String eventName, [
    Map<String, dynamic>? properties,
  ]) async {
    final event = {
      'event_name': eventName,
      'session_id': _sessionId,
      'timestamp': DateTime.now().toIso8601String(),
      'properties': properties ?? {},
    };

    _eventQueue.add(event);
    await _saveEventQueue();

    if (kDebugMode) {
      debugPrint('Analytics Event: $eventName - ${json.encode(properties)}');
    }
  }

  /// Track screen view
  Future<void> trackScreenView(
    String screenName, [
    Map<String, dynamic>? properties,
  ]) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
      'previous_screen': properties?['previous_screen'],
      ...?properties,
    });
  }

  /// Track user action
  Future<void> trackUserAction(
    String action, [
    Map<String, dynamic>? properties,
  ]) async {
    await trackEvent('user_action', {'action': action, ...?properties});
  }

  /// Track e-commerce events
  Future<void> trackPurchase({
    required String orderId,
    required double amount,
    required String currency,
    required List<Map<String, dynamic>> items,
  }) async {
    await trackEvent('purchase', {
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'items': items,
      'item_count': items.length,
    });
  }

  Future<void> trackAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) async {
    await trackEvent('add_to_cart', {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'total_value': price * quantity,
    });
  }

  Future<void> trackRemoveFromCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) async {
    await trackEvent('remove_from_cart', {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'total_value': price * quantity,
    });
  }

  Future<void> trackProductView({
    required String productId,
    required String productName,
    required double price,
    String? category,
  }) async {
    await trackEvent('product_view', {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'category': category,
    });
  }

  Future<void> trackSearch({
    required String searchTerm,
    int? resultCount,
  }) async {
    await trackEvent('search', {
      'search_term': searchTerm,
      'result_count': resultCount,
    });
  }

  Future<void> trackWishlistAction({
    required String action, // 'add' or 'remove'
    required String productId,
    required String productName,
  }) async {
    await trackEvent('wishlist_action', {
      'action': action,
      'product_id': productId,
      'product_name': productName,
    });
  }

  /// Track errors and crashes
  Future<void> trackError({
    required String error,
    required String stackTrace,
    Map<String, dynamic>? context,
  }) async {
    await trackEvent('error', {
      'error_message': error,
      'stack_trace': stackTrace,
      'context': context ?? {},
      'fatal': false,
    });
  }

  Future<void> trackCrash({
    required String error,
    required String stackTrace,
    Map<String, dynamic>? context,
  }) async {
    await trackEvent('crash', {
      'error_message': error,
      'stack_trace': stackTrace,
      'context': context ?? {},
      'fatal': true,
    });
  }

  /// Track performance metrics
  Future<void> trackPerformance({
    required String metric,
    required int value,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent('performance', {
      'metric': metric,
      'value': value,
      'unit': properties?['unit'] ?? 'ms',
      ...?properties,
    });
  }

  /// Set user properties
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    final prefs = await SharedPreferences.getInstance();
    final currentProperties = await getUserProperties();
    final updatedProperties = {...currentProperties, ...properties};

    await prefs.setString(_userPropertiesKey, json.encode(updatedProperties));

    await trackEvent('user_properties_updated', {
      'updated_properties': properties.keys.toList(),
    });
  }

  /// Get user properties
  Future<Map<String, dynamic>> getUserProperties() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final propertiesJson = prefs.getString(_userPropertiesKey);

      if (propertiesJson != null) {
        return Map<String, dynamic>.from(json.decode(propertiesJson));
      }
    } catch (e) {
      debugPrint('Error loading user properties: $e');
    }
    return {};
  }

  /// Get analytics summary
  Future<Map<String, dynamic>> getAnalyticsSummary() async {
    final events = await _getStoredEvents();
    final sessionData = await _getSessionData();
    final userProperties = await getUserProperties();

    // Calculate event counts by type
    final eventCounts = <String, int>{};
    for (final event in events) {
      final eventName = event['event_name'] as String;
      eventCounts[eventName] = (eventCounts[eventName] ?? 0) + 1;
    }

    // Calculate session duration
    int? sessionDuration;
    if (_sessionStartTime != null) {
      sessionDuration = DateTime.now().difference(_sessionStartTime!).inMinutes;
    }

    return {
      'total_events': events.length,
      'session_id': _sessionId,
      'session_duration_minutes': sessionDuration,
      'event_counts': eventCounts,
      'user_properties': userProperties,
      'session_data': sessionData,
    };
  }

  /// Export analytics data
  Future<List<Map<String, dynamic>>> exportEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final events = await _getStoredEvents();

    if (startDate == null && endDate == null) {
      return events;
    }

    return events.where((event) {
      final eventTime = DateTime.parse(event['timestamp'] as String);

      if (startDate != null && eventTime.isBefore(startDate)) {
        return false;
      }

      if (endDate != null && eventTime.isAfter(endDate)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Clear all analytics data
  Future<void> clearAnalyticsData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
    await prefs.remove(_sessionKey);
    await prefs.remove(_userPropertiesKey);

    _eventQueue.clear();
    _sessionId = null;
    _sessionStartTime = null;

    debugPrint('Analytics data cleared');
  }

  /// Private helper methods
  Future<void> _saveEventQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = json.encode(_eventQueue);
      await prefs.setString(_eventsKey, eventsJson);
    } catch (e) {
      debugPrint('Error saving events: $e');
    }
  }

  Future<void> _loadQueuedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getString(_eventsKey);

      if (eventsJson != null) {
        final events = List<Map<String, dynamic>>.from(json.decode(eventsJson));
        _eventQueue.addAll(events);
      }
    } catch (e) {
      debugPrint('Error loading queued events: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getStoredEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getString(_eventsKey);

      if (eventsJson != null) {
        return List<Map<String, dynamic>>.from(json.decode(eventsJson));
      }
    } catch (e) {
      debugPrint('Error getting stored events: $e');
    }
    return [];
  }

  Future<void> _saveSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = {
        'session_id': _sessionId,
        'start_time': _sessionStartTime?.toIso8601String(),
      };
      await prefs.setString(_sessionKey, json.encode(sessionData));
    } catch (e) {
      debugPrint('Error saving session data: $e');
    }
  }

  Future<Map<String, dynamic>> _getSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);

      if (sessionJson != null) {
        return Map<String, dynamic>.from(json.decode(sessionJson));
      }
    } catch (e) {
      debugPrint('Error getting session data: $e');
    }
    return {};
  }
}
