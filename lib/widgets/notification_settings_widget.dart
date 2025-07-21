import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../utils/responsive_helper.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  Map<String, dynamic>? _notificationStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationStatus();
  }

  Future<void> _loadNotificationStatus() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    if (!provider.nativeNotificationsInitialized) {
      await provider.initializeNativeNotifications();
    }

    final status = await provider.getNativeNotificationStatus();
    setState(() {
      _notificationStatus = status;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return Container(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: ResponsiveHelper.responsive(
                      context,
                      mobile: 24.0,
                      tablet: 28.0,
                      desktop: 32.0,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Notification Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Loading indicator
              if (_isLoading) const Center(child: CircularProgressIndicator()),

              // Notification status
              if (!_isLoading && _notificationStatus != null) ...[
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildPermissionSection(notificationProvider),
                const SizedBox(height: 16),
                _buildTestSection(notificationProvider),
                const SizedBox(height: 16),
                _buildHistorySection(notificationProvider),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard() {
    final status = _notificationStatus!;
    final isInitialized = status['isInitialized'] as bool;
    final hasPermission = status['hasPermission'] as bool;
    final isEnabled = status['isEnabled'] as bool;
    final pendingCount = status['pendingCount'] as int;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildStatusRow('Initialized', isInitialized),
            _buildStatusRow('Permission Granted', hasPermission),
            _buildStatusRow('Notifications Enabled', isEnabled),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Pending notifications: $pendingCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: value ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildPermissionSection(NotificationProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permissions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                await provider.requestNativePermissions();
                await _loadNotificationStatus();
              },
              icon: const Icon(Icons.security),
              label: const Text('Request Permissions'),
            ),

            const SizedBox(height: 8),
            Text(
              'Grant notification permissions to receive push notifications from the app.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection(NotificationProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Notifications',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: provider.hasNativePermission
                      ? () async {
                          await provider.addNotificationWithNative(
                            title: 'Test Notification',
                            message: 'This is a test notification!',
                            sendNative: true,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Test notification sent!'),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Test'),
                ),

                ElevatedButton.icon(
                  onPressed: provider.hasNativePermission
                      ? () async {
                          await provider.sendNativeOrderNotification(
                            'ORD123',
                            'shipped',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order notification sent!'),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Order Update'),
                ),

                ElevatedButton.icon(
                  onPressed: provider.hasNativePermission
                      ? () async {
                          await provider.sendNativePromotionalNotification(
                            '🎉 Special Offer!',
                            'Get 20% off on all items today only!',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Promotional notification sent!'),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.local_offer),
                  label: const Text('Promotion'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(NotificationProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'In-App Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (provider.hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${provider.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (provider.notifications.isEmpty)
              const Text('No notifications yet')
            else
              Column(
                children: provider.notifications.take(3).map((notification) {
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      notification.isRead
                          ? Icons.notifications
                          : Icons.notifications_active,
                      color: notification.isRead
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notification.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatTime(notification.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }).toList(),
              ),

            if (provider.notifications.length > 3)
              TextButton(
                onPressed: () {
                  // Navigate to full notifications screen
                },
                child: const Text('View All Notifications'),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
