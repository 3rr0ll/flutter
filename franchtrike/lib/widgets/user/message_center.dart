// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'app_colors.dart';

class MessageCenter extends StatefulWidget {
  const MessageCenter({super.key});

  @override
  State<MessageCenter> createState() => _MessageCenterState();
}

class _MessageCenterState extends State<MessageCenter> {
  // Mock conversations
  final List<Map<String, dynamic>> conversations = [
    {
      'name': 'Franchising Office',
      'lastMessage': 'Your application is under review.',
      'time': '10:15 AM',
      'unread': 2,
      'messages': [
        {
          'from': 'admin',
          'text': 'Your application is under review.',
          'time': '10:15 AM',
        },
        {'from': 'user', 'text': 'Thank you!', 'time': '10:16 AM'},
      ],
    },
    {
      'name': 'Officer Maria',
      'lastMessage': 'Please upload your OR/CR.',
      'time': 'Yesterday',
      'unread': 0,
      'messages': [
        {
          'from': 'admin',
          'text': 'Please upload your OR/CR.',
          'time': 'Yesterday',
        },
        {'from': 'user', 'text': 'Will do, thanks!', 'time': 'Yesterday'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Message Center',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryNavy,
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.create, color: Colors.white),
            tooltip: 'New Message',
            onPressed: () {
              // Compose new message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compose new message ')),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = conversations[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(Icons.account_circle, color: AppColors.primary),
            ),
            title: Text(
              c['name'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              c['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c['time'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (c['unread'] > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${c['unread']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    officerName: c['name'],
                    messages: List<Map<String, String>>.from(c['messages']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String officerName;
  final List<Map<String, String>> messages;
  const ChatScreen({
    super.key,
    required this.officerName,
    required this.messages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<Map<String, String>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List<Map<String, String>>.from(widget.messages);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'from': 'user',
        'text': text,
        'time': _formatTime(DateTime.now()),
      });
      _controller.clear();
    });
    // Optionally, simulate admin reply after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'from': 'admin',
          'text': 'Received: $text',
          'time': _formatTime(DateTime.now()),
        });
      });
    });
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.officerName, style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryNavy,
        leading: BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isUser = m['from'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppColors.primary
                                : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 0),
                              bottomRight: Radius.circular(isUser ? 0 : 16),
                            ),
                          ),
                          child: Text(
                            m['text'] ?? '',
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          m['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Mock attachment
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Attachment')));
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
