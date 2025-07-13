// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class AdminNotifications extends StatelessWidget {
  const AdminNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> automated = [
      {
        'title': 'Franchise Expiring in 7 Days',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'warning',
        'unread': true,
      },
      {
        'title': 'Pending Application: Maria Santos',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'info',
        'unread': false,
      },
      {
        'title': 'Renewal Deadline: Pedro Reyes',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'urgent',
        'unread': true,
      },
    ];

    IconData _iconForType(String type) {
      switch (type) {
        case 'info':
          return Icons.info_outline;
        case 'warning':
          return Icons.warning_amber_rounded;
        case 'urgent':
          return Icons.error_outline;
        default:
          return Icons.notifications_none_rounded;
      }
    }

    Color _colorForType(String type) {
      switch (type) {
        case 'info':
          return Colors.blueAccent;
        case 'warning':
          return Colors.amber;
        case 'urgent':
          return Colors.redAccent;
        default:
          return Colors.grey;
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

    final themeColor = const Color(0xFF1D2761);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: themeColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Automated Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...automated.map((n) => Card(
                color: n['unread'] ? Colors.blue[50] : Colors.white,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Icon(_iconForType(n['type']), color: _colorForType(n['type']), size: 32),
                  title: Text(n['title'], style: TextStyle(fontWeight: n['unread'] ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Text(_formatDate(n['timestamp'])),
                  trailing: n['unread']
                      ? const Icon(Icons.fiber_manual_record, color: Colors.red, size: 16)
                      : const Icon(Icons.done, color: Colors.green, size: 16),
                ),
              )),
        ],
      ),
    );
  }
} 