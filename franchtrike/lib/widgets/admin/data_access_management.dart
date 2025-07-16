import 'package:flutter/material.dart';

class DataAccessManagement extends StatefulWidget {
  const DataAccessManagement({super.key});

  @override
  State<DataAccessManagement> createState() => _DataAccessManagementState();
}

class _DataAccessManagementState extends State<DataAccessManagement> {
  String selectedRole = 'Admin';
  final List<String> roles = ['Admin', 'Operator', 'Franchisee'];

  final List<Map<String, String>> accessLogs = [
    {
      'role': 'Admin',
      'name': 'Garcia',
      'type': 'login',
      'timestamp': '2024-06-10 09:12',
      'ip': '192.168.1.10',
      'location': 'Makati, PH',
    },
    {
      'role': 'Operator',
      'name': 'Santos',
      'type': 'logout',
      'timestamp': '2024-06-10 08:55',
      'ip': '192.168.1.22',
      'location': 'Quezon City, PH',
    },
    {
      'role': 'Franchisee',
      'name': 'Dela Cruz',
      'type': 'login',
      'timestamp': '2024-06-09 18:30',
      'ip': '192.168.1.33',
      'location': 'Pasig, PH',
    },
    {
      'role': 'Admin',
      'name': 'Garcia',
      'type': 'role_change',
      'timestamp': '2024-06-09 17:00',
      'ip': '192.168.1.10',
      'location': 'Makati, PH',
    },
  ];

  final Map<String, List<String>> rolePermissions = {
    'Admin': [
      'View All Data',
      'Manage Users',
      'Approve Applications',
      'Send Notifications',
      'Access Logs',
      'Manage Roles',
      'View Compliance',
    ],
    'Operator': [
      'View Assigned Data',
      'Approve Applications',
      'Send Notifications',
    ],
    'Franchisee': [
      'View Own Data',
      'Submit Applications',
      'Receive Notifications',
    ],
  };

  final List<Map<String, String>> sessions = [
    {
      'user': 'Garcia',
      'role': 'Admin',
      'device': 'Chrome (Windows)',
      'ip': '192.168.1.10',
      'active': 'true',
    },
    {
      'user': 'Santos',
      'role': 'Operator',
      'device': 'Safari (iOS)',
      'ip': '192.168.1.22',
      'active': 'true',
    },
    {
      'user': 'Dela Cruz',
      'role': 'Franchisee',
      'device': 'Edge (Android)',
      'ip': '192.168.1.33',
      'active': 'true',
    },
  ];

  bool encryptionEnabled = true;
  String backupFrequency = 'Daily';
  bool backupHealthy = true;

  void _confirmRevokeSession(int idx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Access'),
        content: Text('Are you sure you want to revoke access for ${sessions[idx]['user']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                sessions.removeAt(idx);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session revoked.')),
              );
            },
            child: const Text('Revoke', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _logIcon(String type) {
    switch (type) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'role_change':
        return Icons.admin_panel_settings;
      default:
        return Icons.info_outline;
    }
  }

  Color _logColor(String type) {
    switch (type) {
      case 'login':
        return Colors.green;
      case 'logout':
        return Colors.orange;
      case 'role_change':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1D2761);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data & Access Management'),
        backgroundColor: themeColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Access Logs
          ExpansionTile(
            leading: const Icon(Icons.history),
            title: const Text('Access Logs', style: TextStyle(fontWeight: FontWeight.bold)),
            children: accessLogs.map((log) {
              return ListTile(
                leading: Icon(_logIcon(log['type']!), color: _logColor(log['type']!)),
                title: Text('${log['role']} - ${log['name']}'),
                subtitle: Text('${log['timestamp']}\n${log['ip']} (${log['location']})'),
                isThreeLine: true,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Role-Based Access
          ExpansionTile(
            leading: const Icon(Icons.security),
            title: const Text('Role-Based Access', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  const Text('Role:'),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedRole,
                    items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (v) => setState(() => selectedRole = v ?? 'Admin'),
                  ),
                ],
              ),
              ...rolePermissions[selectedRole]!.map((perm) => CheckboxListTile(
                    value: true,
                    onChanged: null,
                    title: Text(perm),
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          // Compliance Overview
          ExpansionTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Compliance Overview', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              ListTile(
                leading: Icon(Icons.lock, color: encryptionEnabled ? Colors.green : Colors.red),
                title: const Text('Data Encryption'),
                trailing: Text(encryptionEnabled ? 'Enabled' : 'Disabled', style: TextStyle(color: encryptionEnabled ? Colors.green : Colors.red)),
              ),
              ListTile(
                leading: Icon(Icons.backup, color: backupHealthy ? Colors.green : Colors.red),
                title: const Text('Backup Frequency'),
                trailing: Text(backupFrequency, style: TextStyle(color: backupHealthy ? Colors.green : Colors.red)),
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Access Audit Report'),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Download PDF'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Audit report download (mocked)')),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // User Session Management
          ExpansionTile(
            leading: const Icon(Icons.phonelink_lock),
            title: const Text('User Session Management', style: TextStyle(fontWeight: FontWeight.bold)),
            children: sessions.isEmpty
                ? [const ListTile(title: Text('No active sessions.'))]
                : sessions.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final session = entry.value;
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('${session['user']} (${session['role']})'),
                      subtitle: Text('${session['device']}\n${session['ip']}'),
                      isThreeLine: true,
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => _confirmRevokeSession(idx),
                        child: const Text('Revoke Access', style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }).toList(),
          ),
        ],
      ),
    );
  }
} 