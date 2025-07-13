import 'package:flutter/material.dart';

class AdminMessages extends StatefulWidget {
  const AdminMessages({super.key});

  @override
  State<AdminMessages> createState() => _AdminMessagesState();
}

class _AdminMessagesState extends State<AdminMessages> {
  final List<Map<String, dynamic>> messages = [
    {
      'recipient': 'Juan Dela Cruz',
      'body': 'Please update your documents.',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'Delivered',
      'unread': false,
    },
    {
      'recipient': 'All Franchisees',
      'body': 'Reminder: Training session tomorrow.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Delivered',
      'unread': false,
    },
    {
      'recipient': 'Pedro Reyes',
      'body': 'Your renewal is pending.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'Failed',
      'unread': true,
    },
  ];

  void _composeMessage() async {
    String? recipient;
    String message = '';
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Compose Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: recipient,
                items: [
                  const DropdownMenuItem(value: 'Juan Dela Cruz', child: Text('Juan Dela Cruz')),
                  const DropdownMenuItem(value: 'All Franchisees', child: Text('All Franchisees')),
                  const DropdownMenuItem(value: 'Maria Santos', child: Text('Maria Santos')),
                ],
                onChanged: (v) => recipient = v,
                decoration: const InputDecoration(labelText: 'Recipient'),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => message = v,
                decoration: const InputDecoration(labelText: 'Message'),
                minLines: 2,
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (recipient != null && message.trim().isNotEmpty) {
                  setState(() {
                    messages.insert(0, {
                      'recipient': recipient,
                      'body': message,
                      'date': DateTime.now(),
                      'status': 'Delivered',
                      'unread': false,
                    });
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1D2761);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: themeColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _composeMessage,
        backgroundColor: themeColor,
        icon: const Icon(Icons.edit),
        label: const Text('Compose Message'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Message History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...messages.map((m) => Card(
                color: m['unread'] ? Colors.amber[50] : Colors.white,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Icon(Icons.message, color: themeColor, size: 28),
                  title: Text(m['recipient'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['body']),
                      Text(_formatDate(m['date']), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(m['status'], style: TextStyle(color: m['status'] == 'Delivered' ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        tooltip: 'Delete',
                        onPressed: () {
                          setState(() => messages.remove(m));
                        },
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
} 