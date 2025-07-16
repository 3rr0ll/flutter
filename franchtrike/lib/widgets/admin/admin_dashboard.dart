// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import '../login_screen.dart';
import 'application_details.dart';
import 'franchise_tracker.dart';
import 'admin_notifications.dart';
import 'admin_messages.dart';
import 'data_access_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Mock officer and applications data
  final String officerName = 'Garcia';
  final String officerRole = 'Municipal Officer';
  int selectedTab = 0; // 0 = Applications, 1 = Renewals

  final List<Map<String, dynamic>> applications = [
    {
      'name': 'Juan Dela Cruz',
      'type': 'New',
      'date': '2024-06-10',
      'status': 'Pending',
    },
    {
      'name': 'Maria Santos',
      'type': 'Renewal',
      'date': '2024-06-08',
      'status': 'Approved',
    },
    {
      'name': 'Pedro Reyes',
      'type': 'New',
      'date': '2024-06-05',
      'status': 'Rejected',
    },
    {
      'name': 'Ana Lopez',
      'type': 'Renewal',
      'date': '2024-06-01',
      'status': 'Expiring Soon',
    },
    {
      'name': 'Carlos Lim',
      'type': 'New',
      'date': '2024-05-30',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1D2761);
    final accentPurple = const Color(0xFF5E2D79);
    final accentRed = const Color(0xFFE63946);
    final accentGreen = const Color(0xFF2A9D8F);
    final accentYellow = Colors.amber[700]!;
    final white = Colors.white;

    // Stats
    final pendingCount = applications.where((a) => a['status'] == 'Pending').length;
    final approvedCount = applications.where((a) => a['status'] == 'Approved').length;
    final rejectedCount = applications.where((a) => a['status'] == 'Rejected').length;
    final expiringCount = applications.where((a) => a['status'] == 'Expiring Soon').length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: themeColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminNotifications()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.message_outlined, color: Colors.white),
            tooltip: 'Messages',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminMessages()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, Officer $officerName!',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(officerRole,
                                style: TextStyle(color: accentPurple, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Toggle Tabs
            Row(
              children: [
                _tabButton('Applications', 0, themeColor, accentPurple),
                const SizedBox(width: 8),
                _tabButton('Renewals', 1, themeColor, accentPurple),
              ],
            ),
            const SizedBox(height: 18),
            
            // Data & Access Management Button
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Data & Access Management'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DataAccessManagement()),
                    );
                  },
                ),
              ),
            ),
            // Franchise Tracker Button
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.track_changes),
                  label: const Text('Franchise Tracker'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FranchiseTracker()),
                    );
                  },
                ),
              ),
            ),
            // Overview Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statOverviewCard('Pending', pendingCount, Icons.hourglass_empty, accentYellow),
                _statOverviewCard('Approved', approvedCount, Icons.check_circle, accentGreen),
                _statOverviewCard('Rejected', rejectedCount, Icons.cancel, accentRed),
                _statOverviewCard('Expiring Soon', expiringCount, Icons.warning, accentPurple),
              ],
            ),
            const SizedBox(height: 24),
            // Applications List
            Text(
              selectedTab == 0 ? 'Applications' : 'Renewals',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              itemBuilder: (context, i) {
                final app = applications[i];
                if ((selectedTab == 0 && app['type'] == 'Renewal') ||
                    (selectedTab == 1 && app['type'] == 'New')) {
                  return const SizedBox.shrink();
                }
                return _applicationCard(app);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index, Color themeColor, Color accent) {
    final selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accent, width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : accent,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statOverviewCard(String label, int count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text('$count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _applicationCard(Map<String, dynamic> app) {
    Color statusColor;
    IconData statusIcon;
    switch (app['status']) {
      case 'Approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'Expiring Soon':
        statusColor = Colors.amber[700]!;
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = Colors.amber;
        statusIcon = Icons.hourglass_empty;
    }
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.15),
              child: Icon(statusIcon, color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(app['type']),
                        backgroundColor: app['type'] == 'New' ? Colors.blue[50] : Colors.purple[50],
                        labelStyle: TextStyle(
                          color: app['type'] == 'New' ? Colors.blue : Colors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Submitted: ${app['date']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(app['status']),
                        backgroundColor: statusColor.withOpacity(0.15),
                        labelStyle: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApplicationDetails()),
                );
              },
              child: const Text('View Details', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
