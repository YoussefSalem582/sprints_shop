import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/native_features_service.dart';
import '../services/offline_storage_service.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  bool _hasEverBeenOnline = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final List<String> _pendingSyncData = [];

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
  bool get hasEverBeenOnline => _hasEverBeenOnline;
  List<String> get pendingSyncData => List.unmodifiable(_pendingSyncData);
  int get pendingSyncCount => _pendingSyncData.length;

  ConnectivityProvider() {
    _initConnectivity();
    _startConnectivityListener();
  }

  Future<void> _initConnectivity() async {
    try {
      final isConnected = await NativeFeaturesService.isOnline();
      _updateConnectionStatus(isConnected);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking initial connectivity: $e');
      }
      _updateConnectionStatus(false);
    }
  }

  void _startConnectivityListener() {
    _connectivitySubscription = NativeFeaturesService.connectivityStream.listen(
      (ConnectivityResult result) {
        final isConnected = result != ConnectivityResult.none;
        _updateConnectionStatus(isConnected);
      },
      onError: (error) {
        if (kDebugMode) {
          print('Connectivity stream error: $error');
        }
      },
    );
  }

  void _updateConnectionStatus(bool isConnected) {
    if (_isOnline != isConnected) {
      _isOnline = isConnected;

      if (isConnected) {
        _hasEverBeenOnline = true;
        _onConnectionRestored();
      } else {
        _onConnectionLost();
      }

      notifyListeners();
    }
  }

  void _onConnectionRestored() {
    if (kDebugMode) {
      print('🌐 Connection restored! Syncing pending data...');
    }

    // Trigger data synchronization when connection is restored
    _syncPendingData();

    // Show success feedback
    _showConnectionRestoredFeedback();
  }

  void _onConnectionLost() {
    if (kDebugMode) {
      print('📵 Connection lost! Switching to offline mode...');
    }

    // Show offline mode feedback
    _showOfflineModeActivated();
  }

  // Add data to pending sync queue
  void addToPendingSync(String dataKey, {String? description}) {
    if (!_pendingSyncData.contains(dataKey)) {
      _pendingSyncData.add(dataKey);
      notifyListeners();

      if (kDebugMode) {
        print('📝 Added to pending sync: $dataKey - $description');
      }
    }
  }

  // Remove data from pending sync queue
  void removeFromPendingSync(String dataKey) {
    if (_pendingSyncData.remove(dataKey)) {
      notifyListeners();

      if (kDebugMode) {
        print('✅ Removed from pending sync: $dataKey');
      }
    }
  }

  // Clear all pending sync data
  void clearPendingSync() {
    _pendingSyncData.clear();
    notifyListeners();

    if (kDebugMode) {
      print('🗑️ Cleared all pending sync data');
    }
  }

  // Sync pending data when connection is restored
  Future<void> _syncPendingData() async {
    if (_pendingSyncData.isEmpty) return;

    try {
      final dataToSync = List<String>.from(_pendingSyncData);

      for (final dataKey in dataToSync) {
        await _syncDataItem(dataKey);
        removeFromPendingSync(dataKey);

        // Add small delay to avoid overwhelming the server
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (kDebugMode) {
        print('✨ All pending data synced successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing pending data: $e');
      }
    }
  }

  // Sync individual data item (implement based on your needs)
  Future<void> _syncDataItem(String dataKey) async {
    try {
      // This is where you would implement the actual sync logic
      // For example:
      // - Sync cart items
      // - Sync favorites
      // - Sync user preferences
      // - Upload pending images
      // etc.

      if (kDebugMode) {
        print('🔄 Syncing data item: $dataKey');
      }

      // Simulate sync operation
      await Future.delayed(const Duration(milliseconds: 100));

      // Example sync implementations:
      if (dataKey.startsWith('cart_')) {
        await _syncCartData();
      } else if (dataKey.startsWith('favorites_')) {
        await _syncFavoritesData();
      } else if (dataKey.startsWith('user_')) {
        await _syncUserData(dataKey);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to sync $dataKey: $e');
      }
      rethrow;
    }
  }

  // Specific sync methods
  Future<void> _syncCartData() async {
    // Get offline cart data
    final offlineCart = await OfflineStorageService.getOfflineCart();

    // Sync with server (implement your API calls here)
    if (kDebugMode) {
      print('🛒 Syncing ${offlineCart.length} cart items');
    }
  }

  Future<void> _syncFavoritesData() async {
    // Get offline favorites
    final offlineFavorites = await OfflineStorageService.getOfflineFavorites();

    // Sync with server (implement your API calls here)
    if (kDebugMode) {
      print('❤️ Syncing ${offlineFavorites.length} favorite items');
    }
  }

  Future<void> _syncUserData(String dataKey) async {
    // Sync user-specific data
    if (kDebugMode) {
      print('👤 Syncing user data: $dataKey');
    }
  }

  // Feedback methods (you can customize these based on your UI needs)
  void _showConnectionRestoredFeedback() {
    // This could trigger a snackbar, toast, or other UI feedback
    if (kDebugMode) {
      print('💚 Connection restored - Online mode activated');
    }
  }

  void _showOfflineModeActivated() {
    // This could trigger a snackbar, toast, or other UI feedback
    if (kDebugMode) {
      print('📱 Offline mode activated - Some features may be limited');
    }
  }

  // Manual connectivity check
  Future<void> checkConnectivity() async {
    final isConnected = await NativeFeaturesService.isOnline();
    _updateConnectionStatus(isConnected);
  }

  // Force sync (can be called manually)
  Future<void> forceSyncPendingData() async {
    if (!_isOnline) {
      throw Exception('Cannot sync while offline');
    }

    await _syncPendingData();
  }

  // Get connection status info
  Map<String, dynamic> getConnectionInfo() {
    return {
      'isOnline': _isOnline,
      'hasEverBeenOnline': _hasEverBeenOnline,
      'pendingSyncCount': _pendingSyncData.length,
      'pendingSyncItems': _pendingSyncData,
    };
  }

  // Clean up resources
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // Utility methods for UI
  String getConnectionStatusText() {
    if (_isOnline) {
      return pendingSyncCount > 0 ? 'Online - Syncing data...' : 'Online';
    } else {
      return _hasEverBeenOnline
          ? 'Offline - Working offline'
          : 'Offline - No connection';
    }
  }

  String getConnectionStatusEmoji() {
    if (_isOnline) {
      return '🌐';
    } else {
      return '📵';
    }
  }
}
