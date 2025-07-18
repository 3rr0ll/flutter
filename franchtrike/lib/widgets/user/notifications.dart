// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'notification_settings.dart';
import 'app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Application Approved',
      'message': 'Congratulations! Your franchise application has been approved.',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'type': 'approval',
      'read': false,
    },
    {
      'title': 'Renewal Deadline Approaching',
      'message': 'Renew your franchise before 12/31/2024 to avoid penalties.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'alert',
      'read': false,
    },
    {
      'title': 'Training Session',
      'message': 'Mandatory training session on 11/15/2023.',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'reminder',
      'read': true,
    },
    {
      'title': 'Profile Updated',
      'message': 'Your profile information was updated successfully.',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'type': 'update',
      'read': true,
    },
  ];

  String filter = 'all'; // all, unread, read, alert, reminder, update, approval

  List<Map<String, dynamic>> get filteredNotifications {
    switch (filter) {
      case 'unread':
        return notifications.where((n) => !n['read']).toList();
      case 'read':
        return notifications.where((n) => n['read']).toList();
      case 'alert':
        return notifications.where((n) => n['type'] == 'alert').toList();
      case 'reminder':
        return notifications.where((n) => n['type'] == 'reminder').toList();
      case 'update':
        return notifications.where((n) => n['type'] == 'update').toList();
      case 'approval':
        return notifications.where((n) => n['type'] == 'approval').toList();
      default:
        return notifications;
    }
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['read'] = true;
      }
    });
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'reminder':
        return Icons.notifications_active_rounded;
      case 'update':
        return Icons.info_outline_rounded;
      case 'approval':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'alert':
        return AppColors.red;
      case 'reminder':
        return AppColors.amber;
      case 'update':
        return AppColors.blue;
      case 'approval':
        return AppColors.green;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: themeColor,
        leading: BackButton(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Notification Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationSettings()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: markAllAsRead,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _filterChip('All', 'all'),
                _filterChip('Unread', 'unread'),
                _filterChip('Read', 'read'),
                _filterChip('Alerts', 'alert'),
                _filterChip('Reminders', 'reminder'),
                _filterChip('Updates', 'update'),
                _filterChip('Approvals', 'approval'),
              ],
            ),
          ),
          const Divider(height: 1),
          // Notification list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredNotifications.length,
              itemBuilder: (context, i) {
                final n = filteredNotifications[i];
                final originalIndex = notifications.indexOf(n);
                return Dismissible(
                  key: ValueKey(n['title'] + n['date'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => markAsRead(originalIndex),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: AppColors.green,
                    child: const Icon(Icons.done, color: AppColors.white, size: 32),
                  ),
                  child: GestureDetector(
                    onLongPress: () => markAsRead(originalIndex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: n['read'] ? AppColors.white : AppColors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: _colorForType(n['type']).withOpacity(0.15),
                              child: Icon(_iconForType(n['type']), color: _colorForType(n['type'])),
                            ),
                            if (!n['read'])
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(n['title'], style: TextStyle(fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold)),
                        subtitle: Text(n['message']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatDate(n['date']),
                              style: const TextStyle(fontSize: 12, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = filter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => filter = value),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(color: selected ? AppColors.white : Colors.black87),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
} 