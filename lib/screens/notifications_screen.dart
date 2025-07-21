import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('All'),
                      if (notificationProvider.notifications.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${notificationProvider.notifications.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Unread'),
                      if (notificationProvider.hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${notificationProvider.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.notifications.isEmpty)
                return const SizedBox();

              return PopupMenuButton<String>(
                onSelected: (value) =>
                    _handleMenuAction(value, notificationProvider),
                itemBuilder: (context) => [
                  if (notificationProvider.hasUnread)
                    const PopupMenuItem(
                      value: 'mark_all_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read, size: 20),
                          SizedBox(width: 8),
                          Text('Mark All Read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Clear All', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(showAll: true),
          _buildNotificationsList(showAll: false),
        ],
      ),
    );
  }

  Widget _buildNotificationsList({required bool showAll}) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final notifications = showAll
            ? notificationProvider.notifications
            : notificationProvider.unreadNotifications;

        if (notifications.isEmpty) {
          return _buildEmptyState(showAll);
        }

        return RefreshIndicator(
          onRefresh: () => notificationProvider.loadNotifications(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(notification, notificationProvider);
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(
    AppNotification notification,
    NotificationProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification, provider),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : Theme.of(context).primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(
                        notification.type,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        notification.type.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              notification.type.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: _getNotificationColor(notification.type),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleNotificationAction(
                      value,
                      notification,
                      provider,
                    ),
                    itemBuilder: (context) => [
                      if (!notification.isRead)
                        const PopupMenuItem(
                          value: 'mark_read',
                          child: Row(
                            children: [
                              Icon(Icons.mark_email_read, size: 18),
                              SizedBox(width: 8),
                              Text('Mark as Read'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool showAll) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showAll ? Icons.notifications_none : Icons.mark_email_read,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            showAll ? 'No notifications yet' : 'No unread notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            showAll
                ? 'Notifications will appear here when you receive them'
                : 'All notifications have been read',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (showAll) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _simulateNotifications(),
              icon: const Icon(Icons.notification_add),
              label: const Text('Simulate Notifications'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return Colors.blue;
      case NotificationType.order:
        return Colors.green;
      case NotificationType.offer:
        return Colors.orange;
      case NotificationType.payment:
        return Colors.purple;
      case NotificationType.delivery:
        return Colors.teal;
      case NotificationType.account:
        return Colors.indigo;
    }
  }

  void _handleNotificationTap(
    AppNotification notification,
    NotificationProvider provider,
  ) {
    if (!notification.isRead) {
      provider.markAsRead(notification.id);
    }

    // Handle navigation based on notification type and data
    if (notification.data != null) {
      final data = notification.data!;

      if (notification.type == NotificationType.order &&
          data['orderId'] != null) {
        // Navigate to order details
        _showSnackBar('Navigating to order ${data['orderId']}');
      } else if (notification.type == NotificationType.offer) {
        // Navigate to offers or specific products
        _showSnackBar('Opening special offer');
      }
    }
  }

  void _handleNotificationAction(
    String action,
    AppNotification notification,
    NotificationProvider provider,
  ) {
    switch (action) {
      case 'mark_read':
        provider.markAsRead(notification.id);
        break;
      case 'delete':
        provider.deleteNotification(notification.id);
        _showSnackBar('Notification deleted');
        break;
    }
  }

  void _handleMenuAction(String action, NotificationProvider provider) {
    switch (action) {
      case 'mark_all_read':
        provider.markAllAsRead();
        _showSnackBar('All notifications marked as read');
        break;
      case 'clear_all':
        _showClearAllDialog(provider);
        break;
    }
  }

  void _showClearAllDialog(NotificationProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAllNotifications();
              Navigator.of(ctx).pop();
              _showSnackBar('All notifications cleared');
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _simulateNotifications() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);

    _showSnackBar('Simulating notifications...');

    // Add sample notifications
    await provider.addNotification(
      title: '🎉 Welcome Back!',
      message: 'Check out our latest products and special offers.',
      type: NotificationType.general,
    );

    await Future.delayed(const Duration(seconds: 1));

    await provider.addNotification(
      title: '📦 Order Update',
      message: 'Your order #123456 has been shipped and will arrive soon.',
      type: NotificationType.order,
      data: {'orderId': 'ORD-123456', 'status': 'shipped'},
    );

    await Future.delayed(const Duration(seconds: 1));

    await provider.addNotification(
      title: '🔥 Flash Sale!',
      message: 'Get 50% off on selected items. Only 2 hours left!',
      type: NotificationType.offer,
      data: {'discount': 50, 'duration': '2 hours'},
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
