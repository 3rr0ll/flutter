// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import '../../primary_action_button.dart';

class FranchiseTracker extends StatefulWidget {
  const FranchiseTracker({super.key});

  @override
  State<FranchiseTracker> createState() => _FranchiseTrackerState();
}

class _FranchiseTrackerState extends State<FranchiseTracker> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String search = '';
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Barangay 1', 'Barangay 2', 'Route A', 'Route B'];

  final List<Map<String, String>> franchises = [
    {
      'operator': 'Juan Dela Cruz',
      'plate': 'ABC-1234',
      'expiry': '2025-06-10',
      'status': 'Active',
      'barangay': 'Barangay 1',
      'route': 'Route A',
    },
    {
      'operator': 'Maria Santos',
      'plate': 'XYZ-5678',
      'expiry': '2024-07-01',
      'status': 'Expiring Soon',
      'barangay': 'Barangay 2',
      'route': 'Route B',
    },
    {
      'operator': 'Pedro Reyes',
      'plate': 'LMN-4321',
      'expiry': '2023-12-01',
      'status': 'Expired',
      'barangay': 'Barangay 1',
      'route': 'Route A',
    },
    {
      'operator': 'Ana Lopez',
      'plate': 'QWE-9876',
      'expiry': '2024-06-15',
      'status': 'Expiring Soon',
      'barangay': 'Barangay 2',
      'route': 'Route B',
    },
    {
      'operator': 'Carlos Lim',
      'plate': 'JKL-2468',
      'expiry': '2026-01-20',
      'status': 'Active',
      'barangay': 'Barangay 1',
      'route': 'Route A',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredFranchises {
    final tab = _tabController.index;
    String statusFilter = tab == 0 ? 'Active' : tab == 1 ? 'Expiring Soon' : 'Expired';
    return franchises.where((f) {
      final matchesStatus = f['status'] == statusFilter;
      final matchesSearch = search.isEmpty || f['operator']!.toLowerCase().contains(search.toLowerCase()) || f['plate']!.toLowerCase().contains(search.toLowerCase());
      final matchesFilter = selectedFilter == 'All' || f['barangay'] == selectedFilter || f['route'] == selectedFilter;
      return matchesStatus && matchesSearch && matchesFilter;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Expiring Soon':
        return Colors.orange;
      case 'Expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Active':
        return Icons.check_circle;
      case 'Expiring Soon':
        return Icons.warning;
      case 'Expired':
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1D2761);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Franchise Tracker'),
        backgroundColor: themeColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Expiring Soon'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by operator or plate',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => search = v),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: filters.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                  onChanged: (v) => setState(() => selectedFilter = v ?? 'All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(3, (tabIdx) {
                final list = filteredFranchises;
                if (list.isEmpty) {
                  return const Center(child: Text('No franchises found.'));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final f = list[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _statusColor(f['status']!).withOpacity(0.15),
                          child: Icon(_statusIcon(f['status']!), color: _statusColor(f['status']!)),
                        ),
                        title: Text(f['operator']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Plate: ${f['plate']}'),
                            Text('Expires: ${f['expiry']}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Chip(
                              label: Text(f['status']!),
                              backgroundColor: _statusColor(f['status']!).withOpacity(0.15),
                              labelStyle: TextStyle(color: _statusColor(f['status']!), fontWeight: FontWeight.bold),
                            ),
                            // Removed PrimaryActionButton to fix pixel overflow
                          ],
                        ),
                        onTap: () {
                         
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Show profile for ${f['operator']} (mock)')),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
} 