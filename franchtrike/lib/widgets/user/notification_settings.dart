// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'app_colors.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool inApp = true;
  bool email = true;
  bool sms = false;

  List<Map<String, dynamic>> history = [
    {
      'type': 'approval',
      'title': 'Renewal Approved',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'read': false,
    },
    {
      'type': 'payment',
      'title': 'Payment Confirmed',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'read': true,
    },
    {
      'type': 'reminder',
      'title': 'Renewal Deadline Approaching',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'read': false,
    },
  ];

  void markAllAsRead() {
    setState(() {
      for (var n in history) {
        n['read'] = true;
      }
    });
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'approval':
        return Icons.check_circle_outline;
      case 'payment':
        return Icons.attach_money;
      case 'reminder':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'approval':
        return AppColors.success;
      case 'payment':
        return AppColors.primary;
      case 'reminder':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: themeColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile.adaptive(
            value: inApp,
            onChanged: (v) => setState(() => inApp = v),
            title: const Text('Enable In-App Notifications'),
            secondary: const Icon(Icons.notifications_active),
          ),
          SwitchListTile.adaptive(
            value: email,
            onChanged: (v) => setState(() => email = v),
            title: const Text('Enable Email Notifications'),
            secondary: const Icon(Icons.email),
          ),
          SwitchListTile.adaptive(
            value: sms,
            onChanged: (v) => setState(() => sms = v),
            title: const Text('Enable SMS Notifications'),
            secondary: const Icon(Icons.sms),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notification History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton.icon(
                onPressed: markAllAsRead,
                icon: const Icon(Icons.done_all),
                label: const Text('Mark All as Read'),
              ),
            ],
          ),
          AnimatedList(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            initialItemCount: history.length,
            itemBuilder: (context, i, animation) {
              final n = history[i];
              return SizeTransition(
                sizeFactor: animation,
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
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
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(n['title'], style: TextStyle(fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold)),
                    subtitle: Text(_formatDate(n['time'])),
                    trailing: n['read']
                        ? const Icon(Icons.done, color: AppColors.success, size: 18)
                        : const Icon(Icons.fiber_manual_record, color: AppColors.danger, size: 18),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 