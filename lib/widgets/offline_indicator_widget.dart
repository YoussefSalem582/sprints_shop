import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';
import '../utils/responsive_helper.dart';

class OfflineIndicatorWidget extends StatelessWidget {
  final bool showOnlineStatus;
  final bool showPendingSync;

  const OfflineIndicatorWidget({
    super.key,
    this.showOnlineStatus = true,
    this.showPendingSync = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        // Don't show anything if online and no pending sync
        if (connectivity.isOnline &&
            (!showPendingSync || connectivity.pendingSyncCount == 0)) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: _buildIndicator(context, connectivity),
        );
      },
    );
  }

  Widget _buildIndicator(
    BuildContext context,
    ConnectivityProvider connectivity,
  ) {
    if (connectivity.isOffline) {
      return _buildOfflineIndicator(context, connectivity);
    } else if (connectivity.pendingSyncCount > 0) {
      return _buildSyncingIndicator(context, connectivity);
    }

    return const SizedBox.shrink();
  }

  Widget _buildOfflineIndicator(
    BuildContext context,
    ConnectivityProvider connectivity,
  ) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.responsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        border: Border(
          bottom: BorderSide(color: Colors.orange[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: Colors.orange[700],
            size: ResponsiveHelper.getIconSize(context, baseSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Working Offline',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getTextSize(context, 14),
                  ),
                ),
                if (connectivity.pendingSyncCount > 0)
                  Text(
                    '${connectivity.pendingSyncCount} items pending sync',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: ResponsiveHelper.getTextSize(context, 12),
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showOfflineDetails(context, connectivity),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange[700],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'Details',
              style: TextStyle(
                fontSize: ResponsiveHelper.getTextSize(context, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncingIndicator(
    BuildContext context,
    ConnectivityProvider connectivity,
  ) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.responsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border(bottom: BorderSide(color: Colors.blue[300]!, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.getIconSize(context, baseSize: 18),
            height: ResponsiveHelper.getIconSize(context, baseSize: 18),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Syncing Data',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getTextSize(context, 14),
                  ),
                ),
                Text(
                  '${connectivity.pendingSyncCount} items remaining',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: ResponsiveHelper.getTextSize(context, 12),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showSyncDetails(context, connectivity),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'View',
              style: TextStyle(
                fontSize: ResponsiveHelper.getTextSize(context, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOfflineDetails(
    BuildContext context,
    ConnectivityProvider connectivity,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cloud_off, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text('Offline Mode'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You\'re currently working offline. The following features are available:',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(Icons.shopping_cart, 'Browse cached products'),
            _buildFeatureItem(Icons.favorite, 'Manage favorites'),
            _buildFeatureItem(Icons.shopping_bag, 'View cart items'),
            const SizedBox(height: 16),
            if (connectivity.pendingSyncCount > 0) ...[
              Text(
                'Pending sync: ${connectivity.pendingSyncCount} items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your data will sync automatically when connection is restored.',
              ),
            ] else ...[
              const Text('All your data is up to date.'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await connectivity.checkConnectivity();
            },
            child: const Text('Check Connection'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSyncDetails(
    BuildContext context,
    ConnectivityProvider connectivity,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.sync, color: Colors.blue[600]),
            const SizedBox(width: 8),
            const Text('Syncing Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Syncing ${connectivity.pendingSyncCount} items with the server:',
            ),
            const SizedBox(height: 16),
            ...connectivity.pendingSyncData.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.sync, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Please wait while we sync your data...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// Banner version for full-width display
class OfflineBannerWidget extends StatelessWidget {
  const OfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (connectivity.isOnline && connectivity.pendingSyncCount == 0) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: connectivity.isOffline ? Colors.red[100] : Colors.blue[100],
            border: Border.all(
              color: connectivity.isOffline
                  ? Colors.red[300]!
                  : Colors.blue[300]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                connectivity.isOffline ? Icons.cloud_off : Icons.sync,
                color: connectivity.isOffline
                    ? Colors.red[700]
                    : Colors.blue[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  connectivity.getConnectionStatusText(),
                  style: TextStyle(
                    color: connectivity.isOffline
                        ? Colors.red[800]
                        : Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (connectivity.isOffline)
                TextButton(
                  onPressed: () => connectivity.checkConnectivity(),
                  child: const Text('Retry'),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Floating action button for manual sync
class OfflineSyncFab extends StatelessWidget {
  const OfflineSyncFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (connectivity.isOffline || connectivity.pendingSyncCount == 0) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.small(
          onPressed: () async {
            try {
              await connectivity.forceSyncPendingData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data synced successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sync failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          backgroundColor: Colors.blue[600],
          child: const Icon(Icons.sync, color: Colors.white),
        );
      },
    );
  }
}
