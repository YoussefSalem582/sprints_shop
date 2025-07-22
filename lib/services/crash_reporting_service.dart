import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Crash reporting service for capturing and reporting app crashes
class CrashReportingService {
  static final CrashReportingService _instance =
      CrashReportingService._internal();
  factory CrashReportingService() => _instance;
  CrashReportingService._internal();

  static const String _crashReportsKey = 'crash_reports';
  static const String _errorCountKey = 'error_count';
  static const String _lastCrashKey = 'last_crash_timestamp';

  bool _isInitialized = false;
  late SharedPreferences _prefs;

  /// Initialize crash reporting
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();

    // Set up global error handlers
    FlutterError.onError = _handleFlutterError;
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await _handleIsolateError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort,
    );

    // Set up zone error handler
    runZonedGuarded(() {
      // App initialization would happen here
    }, _handleZoneError);

    _isInitialized = true;
    debugPrint('Crash reporting service initialized');
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    // Report the error
    _reportError(
      error: details.exception,
      stackTrace: details.stack,
      context: 'Flutter Framework',
      details: {
        'library': details.library,
        'informationCollector': details.informationCollector?.toString(),
        'silent': details.silent,
      },
    );

    // Call the original error handler in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  }

  /// Handle isolate errors
  Future<void> _handleIsolateError(dynamic error, dynamic stackTrace) async {
    await _reportError(
      error: error,
      stackTrace: stackTrace,
      context: 'Isolate',
    );
  }

  /// Handle zone errors
  void _handleZoneError(Object error, StackTrace stackTrace) {
    _reportError(error: error, stackTrace: stackTrace, context: 'Zone');
  }

  /// Report an error manually
  Future<void> reportError({
    required dynamic error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
    bool fatal = false,
  }) async {
    await _reportError(
      error: error,
      stackTrace: stackTrace,
      context: context ?? 'Manual Report',
      details: additionalData,
      fatal: fatal,
    );
  }

  /// Internal error reporting method
  Future<void> _reportError({
    required dynamic error,
    StackTrace? stackTrace,
    required String context,
    Map<String, dynamic>? details,
    bool fatal = false,
  }) async {
    try {
      final crashReport = await _createCrashReport(
        error: error,
        stackTrace: stackTrace,
        context: context,
        details: details,
        fatal: fatal,
      );

      await _storeCrashReport(crashReport);
      await _updateErrorStats();

      if (kDebugMode) {
        debugPrint('Crash reported: $error');
        debugPrint('Context: $context');
        if (stackTrace != null) {
          debugPrint('Stack trace: $stackTrace');
        }
      }
    } catch (e) {
      debugPrint('Failed to report crash: $e');
    }
  }

  /// Create a detailed crash report
  Future<Map<String, dynamic>> _createCrashReport({
    required dynamic error,
    StackTrace? stackTrace,
    required String context,
    Map<String, dynamic>? details,
    bool fatal = false,
  }) async {
    final timestamp = DateTime.now();

    return {
      'id': _generateCrashId(timestamp),
      'timestamp': timestamp.toIso8601String(),
      'error': error.toString(),
      'error_type': error.runtimeType.toString(),
      'stack_trace': stackTrace?.toString(),
      'context': context,
      'fatal': fatal,
      'platform': Platform.operatingSystem,
      'platform_version': Platform.operatingSystemVersion,
      'app_version': '1.0.0', // This would come from package info
      'device_info': await _getDeviceInfo(),
      'memory_usage': await _getMemoryInfo(),
      'additional_details': details,
    };
  }

  /// Generate unique crash ID
  String _generateCrashId(DateTime timestamp) {
    return 'crash_${timestamp.millisecondsSinceEpoch}_${timestamp.hashCode.abs()}';
  }

  /// Get device information
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      return {
        'platform': Platform.operatingSystem,
        'platform_version': Platform.operatingSystemVersion,
        'locale': Platform.localeName,
        'number_of_processors': Platform.numberOfProcessors,
        'dart_version': Platform.version,
      };
    } catch (e) {
      return {'error': 'Failed to get device info: $e'};
    }
  }

  /// Get memory information
  Future<Map<String, dynamic>> _getMemoryInfo() async {
    try {
      // This would be implemented with platform-specific code
      return {
        'available_memory_mb': 0,
        'used_memory_mb': 0,
        'memory_pressure': 'unknown',
      };
    } catch (e) {
      return {'error': 'Failed to get memory info: $e'};
    }
  }

  /// Store crash report locally
  Future<void> _storeCrashReport(Map<String, dynamic> crashReport) async {
    try {
      final existingReports = await getCrashReports();
      existingReports.add(crashReport);

      // Keep only the last 50 crash reports
      if (existingReports.length > 50) {
        existingReports.removeRange(0, existingReports.length - 50);
      }

      final reportsJson = existingReports
          .map((report) => jsonEncode(report))
          .toList();
      await _prefs.setStringList(_crashReportsKey, reportsJson);
      await _prefs.setString(_lastCrashKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to store crash report: $e');
    }
  }

  /// Update error statistics
  Future<void> _updateErrorStats() async {
    try {
      final currentCount = _prefs.getInt(_errorCountKey) ?? 0;
      await _prefs.setInt(_errorCountKey, currentCount + 1);
    } catch (e) {
      debugPrint('Failed to update error stats: $e');
    }
  }

  /// Get all stored crash reports
  Future<List<Map<String, dynamic>>> getCrashReports() async {
    try {
      final reportsJson = _prefs.getStringList(_crashReportsKey) ?? [];
      return reportsJson
          .map((json) {
            try {
              return Map<String, dynamic>.from(jsonDecode(json));
            } catch (e) {
              debugPrint('Failed to decode crash report: $e');
              return <String, dynamic>{};
            }
          })
          .where((report) => report.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Failed to get crash reports: $e');
      return [];
    }
  }

  /// Get crash statistics
  Future<Map<String, dynamic>> getCrashStatistics() async {
    try {
      final reports = await getCrashReports();
      final totalErrors = _prefs.getInt(_errorCountKey) ?? 0;
      final lastCrashTimestamp = _prefs.getString(_lastCrashKey);

      // Analyze crash patterns
      final errorTypes = <String, int>{};
      final contexts = <String, int>{};
      final platformCrashes = <String, int>{};
      int fatalCrashes = 0;

      for (final report in reports) {
        final errorType = report['error_type'] as String? ?? 'Unknown';
        final context = report['context'] as String? ?? 'Unknown';
        final platform = report['platform'] as String? ?? 'Unknown';
        final fatal = report['fatal'] as bool? ?? false;

        errorTypes[errorType] = (errorTypes[errorType] ?? 0) + 1;
        contexts[context] = (contexts[context] ?? 0) + 1;
        platformCrashes[platform] = (platformCrashes[platform] ?? 0) + 1;

        if (fatal) fatalCrashes++;
      }

      return {
        'total_crashes': reports.length,
        'total_errors': totalErrors,
        'fatal_crashes': fatalCrashes,
        'last_crash': lastCrashTimestamp,
        'crash_by_error_type': errorTypes,
        'crash_by_context': contexts,
        'crash_by_platform': platformCrashes,
        'crash_rate': reports.isEmpty ? 0.0 : fatalCrashes / reports.length,
      };
    } catch (e) {
      debugPrint('Failed to get crash statistics: $e');
      return {};
    }
  }

  /// Get recent crashes (last 24 hours)
  Future<List<Map<String, dynamic>>> getRecentCrashes({int hours = 24}) async {
    try {
      final reports = await getCrashReports();
      final cutoffTime = DateTime.now().subtract(Duration(hours: hours));

      return reports.where((report) {
        final timestampStr = report['timestamp'] as String?;
        if (timestampStr == null) return false;

        try {
          final timestamp = DateTime.parse(timestampStr);
          return timestamp.isAfter(cutoffTime);
        } catch (e) {
          return false;
        }
      }).toList();
    } catch (e) {
      debugPrint('Failed to get recent crashes: $e');
      return [];
    }
  }

  /// Clear all crash reports
  Future<void> clearCrashReports() async {
    try {
      await _prefs.remove(_crashReportsKey);
      await _prefs.remove(_errorCountKey);
      await _prefs.remove(_lastCrashKey);
      debugPrint('Crash reports cleared');
    } catch (e) {
      debugPrint('Failed to clear crash reports: $e');
    }
  }

  /// Export crash reports
  Future<String> exportCrashReports() async {
    try {
      final reports = await getCrashReports();
      final statistics = await getCrashStatistics();

      final exportData = {
        'export_timestamp': DateTime.now().toIso8601String(),
        'statistics': statistics,
        'crash_reports': reports,
      };

      return jsonEncode(exportData);
    } catch (e) {
      debugPrint('Failed to export crash reports: $e');
      return '{"error": "Failed to export crash reports"}';
    }
  }

  /// Check if app crashed in the previous session
  Future<bool> didCrashInPreviousSession() async {
    try {
      final lastCrashTimestamp = _prefs.getString(_lastCrashKey);
      if (lastCrashTimestamp == null) return false;

      final lastCrash = DateTime.parse(lastCrashTimestamp);
      final timeSinceLastCrash = DateTime.now().difference(lastCrash);

      // Consider it a previous session crash if it happened less than 1 hour ago
      return timeSinceLastCrash.inHours < 1;
    } catch (e) {
      return false;
    }
  }

  /// Get crash trends over time
  Future<Map<String, List<int>>> getCrashTrends({int days = 7}) async {
    try {
      final reports = await getCrashReports();
      final trends = <String, List<int>>{};

      for (int i = days - 1; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        final crashesOnDay = reports.where((report) {
          final timestampStr = report['timestamp'] as String?;
          if (timestampStr == null) return false;

          try {
            final timestamp = DateTime.parse(timestampStr);
            return timestamp.year == date.year &&
                timestamp.month == date.month &&
                timestamp.day == date.day;
          } catch (e) {
            return false;
          }
        }).length;

        trends[dateKey] = [crashesOnDay];
      }

      return trends;
    } catch (e) {
      debugPrint('Failed to get crash trends: $e');
      return {};
    }
  }

  /// Dispose the service
  void dispose() {
    // Clean up any resources if needed
  }
}
