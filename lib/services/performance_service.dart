import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'analytics_service.dart';

/// Performance monitoring service for tracking app performance metrics
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, List<int>> _performanceMetrics = {};
  Timer? _memoryMonitorTimer;
  bool _isMonitoring = false;

  /// Initialize performance monitoring
  Future<void> initialize() async {
    await _startMemoryMonitoring();
    await _trackAppStartup();
    debugPrint('Performance monitoring initialized');
  }

  /// Track operation timing
  void startTiming(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
  }

  /// End timing and record the duration
  Future<void> endTiming(
    String operationName, [
    Map<String, dynamic>? properties,
  ]) async {
    final startTime = _operationStartTimes[operationName];
    if (startTime == null) {
      debugPrint('Warning: No start time found for operation: $operationName');
      return;
    }

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    _operationStartTimes.remove(operationName);

    // Store metric
    _performanceMetrics.putIfAbsent(operationName, () => []).add(duration);

    // Track in analytics
    await AnalyticsService().trackPerformance(
      metric: operationName,
      value: duration,
      properties: properties,
    );

    if (kDebugMode) {
      debugPrint('Performance: $operationName took ${duration}ms');
    }
  }

  /// Track widget build performance
  Future<void> trackWidgetBuild(String widgetName, int buildTimeMs) async {
    _performanceMetrics
        .putIfAbsent('widget_build_$widgetName', () => [])
        .add(buildTimeMs);

    await AnalyticsService().trackPerformance(
      metric: 'widget_build',
      value: buildTimeMs,
      properties: {'widget_name': widgetName},
    );
  }

  /// Track navigation performance
  Future<void> trackNavigation(
    String fromScreen,
    String toScreen,
    int navigationTimeMs,
  ) async {
    await AnalyticsService().trackPerformance(
      metric: 'navigation',
      value: navigationTimeMs,
      properties: {'from_screen': fromScreen, 'to_screen': toScreen},
    );
  }

  /// Track network request performance
  Future<void> trackNetworkRequest({
    required String endpoint,
    required int durationMs,
    required int statusCode,
    int? responseSize,
  }) async {
    await AnalyticsService().trackPerformance(
      metric: 'network_request',
      value: durationMs,
      properties: {
        'endpoint': endpoint,
        'status_code': statusCode,
        'response_size': responseSize,
        'success': statusCode >= 200 && statusCode < 300,
      },
    );
  }

  /// Track image loading performance
  Future<void> trackImageLoad(
    String imageUrl,
    int loadTimeMs,
    bool success,
  ) async {
    await AnalyticsService().trackPerformance(
      metric: 'image_load',
      value: loadTimeMs,
      properties: {'image_url': imageUrl, 'success': success},
    );
  }

  /// Track database operation performance
  Future<void> trackDatabaseOperation(String operation, int durationMs) async {
    await AnalyticsService().trackPerformance(
      metric: 'database_operation',
      value: durationMs,
      properties: {'operation': operation},
    );
  }

  /// Track frame rendering performance
  Future<void> trackFrameMetrics({
    required double frameRate,
    required int droppedFrames,
    required double averageFrameTime,
  }) async {
    await AnalyticsService().trackPerformance(
      metric: 'frame_rendering',
      value: frameRate.round(),
      properties: {
        'dropped_frames': droppedFrames,
        'average_frame_time': averageFrameTime,
        'unit': 'fps',
      },
    );
  }

  /// Get memory usage information
  Future<Map<String, dynamic>> getMemoryUsage() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Platform-specific memory information would be implemented here
        // For now, we'll return mock data
        return {
          'used_memory_mb': 0,
          'available_memory_mb': 0,
          'total_memory_mb': 0,
          'memory_pressure': 'normal',
        };
      }
    } catch (e) {
      debugPrint('Error getting memory usage: $e');
    }

    return {
      'used_memory_mb': 0,
      'available_memory_mb': 0,
      'total_memory_mb': 0,
      'memory_pressure': 'unknown',
    };
  }

  /// Start continuous memory monitoring
  Future<void> _startMemoryMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _memoryMonitorTimer = Timer.periodic(const Duration(minutes: 1), (
      timer,
    ) async {
      final memoryUsage = await getMemoryUsage();

      await AnalyticsService().trackPerformance(
        metric: 'memory_usage',
        value: memoryUsage['used_memory_mb'] as int,
        properties: {
          'available_memory_mb': memoryUsage['available_memory_mb'],
          'memory_pressure': memoryUsage['memory_pressure'],
          'unit': 'mb',
        },
      );
    });
  }

  /// Stop memory monitoring
  void stopMemoryMonitoring() {
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = null;
    _isMonitoring = false;
  }

  /// Track app startup performance
  Future<void> _trackAppStartup() async {
    // This would be called from main() to track total startup time
    await AnalyticsService().trackPerformance(
      metric: 'app_startup',
      value: DateTime.now().millisecondsSinceEpoch,
      properties: {
        'platform': Platform.operatingSystem,
        'app_version': '1.0.0', // This would come from package info
      },
    );
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final summary = <String, Map<String, dynamic>>{};

    for (final entry in _performanceMetrics.entries) {
      final metrics = entry.value;
      if (metrics.isNotEmpty) {
        summary[entry.key] = {
          'count': metrics.length,
          'average': metrics.reduce((a, b) => a + b) / metrics.length,
          'min': metrics.reduce((a, b) => a < b ? a : b),
          'max': metrics.reduce((a, b) => a > b ? a : b),
          'total': metrics.reduce((a, b) => a + b),
        };
      }
    }

    return {
      'metrics_summary': summary,
      'monitoring_active': _isMonitoring,
      'total_operations': _performanceMetrics.length,
    };
  }

  /// Detect performance issues
  List<Map<String, dynamic>> detectPerformanceIssues() {
    final issues = <Map<String, dynamic>>[];

    for (final entry in _performanceMetrics.entries) {
      final metrics = entry.value;
      if (metrics.isEmpty) continue;

      final average = metrics.reduce((a, b) => a + b) / metrics.length;
      final operationName = entry.key;

      // Define thresholds for different operations
      int threshold = 1000; // Default 1 second

      if (operationName.contains('widget_build')) {
        threshold = 16; // 60fps target
      } else if (operationName.contains('navigation')) {
        threshold = 300;
      } else if (operationName.contains('network_request')) {
        threshold = 5000;
      } else if (operationName.contains('database_operation')) {
        threshold = 100;
      }

      if (average > threshold) {
        issues.add({
          'operation': operationName,
          'average_duration': average,
          'threshold': threshold,
          'severity': average > threshold * 2 ? 'high' : 'medium',
          'suggestion': _getPerformanceSuggestion(operationName),
        });
      }
    }

    return issues;
  }

  /// Get performance improvement suggestions
  String _getPerformanceSuggestion(String operationName) {
    if (operationName.contains('widget_build')) {
      return 'Consider using const constructors, avoiding expensive operations in build(), or implementing shouldRebuild logic.';
    } else if (operationName.contains('navigation')) {
      return 'Check for heavy widget trees or synchronous operations during navigation.';
    } else if (operationName.contains('network_request')) {
      return 'Consider implementing request caching, using lighter payloads, or optimizing server response times.';
    } else if (operationName.contains('image_load')) {
      return 'Try image compression, caching, or using placeholder images.';
    } else if (operationName.contains('database_operation')) {
      return 'Consider database indexing, query optimization, or connection pooling.';
    }

    return 'Review the operation for potential optimizations.';
  }

  /// Clear performance data
  void clearPerformanceData() {
    _performanceMetrics.clear();
    _operationStartTimes.clear();
    debugPrint('Performance data cleared');
  }

  /// Dispose the service
  void dispose() {
    stopMemoryMonitoring();
    clearPerformanceData();
  }
}
