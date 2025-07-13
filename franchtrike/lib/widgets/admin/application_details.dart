// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';

class ApplicationDetails extends StatefulWidget {
  const ApplicationDetails({super.key});

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  // Mock data
  final String applicantName = 'Juan Dela Cruz';
  final String applicationType = 'New';
  final String dateSubmitted = '2024-06-10';
  String status = 'Pending';
  final List<Map<String, String>> documents = [
    {
      'name': 'Valid ID',
      'type': 'image',
      'file': 'id_sample.png',
    },
    {
      'name': 'OR/CR',
      'type': 'pdf',
      'file': 'orcr_sample.pdf',
    },
  ];
  String decision = 'Approve';
  final List<String> decisionOptions = ['Approve', 'Reject', 'Request More Info'];
  final TextEditingController _remarksController = TextEditingController();

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _docIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1D2761);
    final accentPurple = const Color(0xFF5E2D79);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: themeColor,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Application Info
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(applicantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(applicationType),
                          backgroundColor: applicationType == 'New' ? Colors.blue[50] : Colors.purple[50],
                          labelStyle: TextStyle(
                            color: applicationType == 'New' ? Colors.blue : accentPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Submitted: $dateSubmitted', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(status),
                          backgroundColor: _statusColor(status).withOpacity(0.15),
                          labelStyle: TextStyle(color: _statusColor(status), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Uploaded Documents
            const Text('Uploaded Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...documents.map((doc) => Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(_docIcon(doc['type']!), color: themeColor, size: 32),
                    title: Text(doc['name']!),
                    subtitle: Text((doc['file'] ?? '').toString()),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Mock view
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Viewing ${doc['name']} (mock)')),
                        );
                      },
                      child: const Text('View', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            // Action Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Take Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: decision,
                      items: decisionOptions
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setState(() => decision = v ?? decision),
                      decoration: const InputDecoration(
                        labelText: 'Decision',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _remarksController,
                      decoration: const InputDecoration(
                        labelText: 'Remarks / Notes',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Decision'),
                              content: Text('Are you sure you want to "$decision" this application?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            setState(() => status = decision);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Decision "$decision" submitted!')),
                            );
                          }
                        },
                        child: const Text('Submit Decision', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 