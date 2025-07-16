import 'package:flutter/material.dart';
import 'app_colors.dart';

class ViewApplicationStatus extends StatefulWidget {
  const ViewApplicationStatus({super.key});

  @override
  State<ViewApplicationStatus> createState() => _ViewApplicationStatusState();
}

class _ViewApplicationStatusState extends State<ViewApplicationStatus> {
  // Mock data for demonstration
  String status = 'Under Review'; // Submitted | Under Review | Approved | Rejected
  String rejectionReason = 'Incomplete documents';
  String applicationId = 'APP-20240601-001';
  String franchiseType = 'New';
  DateTime submissionDate = DateTime(2024, 6, 1);
  bool isRefreshing = false;

  Future<void> _refreshStatus() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    // Here you would fetch updated status from backend
    setState(() => isRefreshing = false);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppColors.success;
      case 'Rejected':
        return AppColors.error;
      case 'Under Review':
        return AppColors.warning;
      case 'Submitted':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle_outline;
      case 'Rejected':
        return Icons.cancel_outlined;
      case 'Under Review':
        return Icons.hourglass_empty;
      case 'Submitted':
        return Icons.send;
      default:
        return Icons.help_outline;
    }
  }

  int _currentStep(String status) {
    switch (status) {
      case 'Submitted':
        return 0;
      case 'Under Review':
        return 1;
      case 'Approved':
        return 3;
      case 'Rejected':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
        backgroundColor: AppColors.primary,
        leading: BackButton(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    _statusIcon(status),
                    color: _statusColor(status),
                    size: 40,
                  ),
                  title: const Text(
                    'Current Status',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Timeline / Stepper
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stepper(
                  currentStep: _currentStep(status),
                  controlsBuilder: (context, details) => const SizedBox.shrink(),
                  steps: [
                    Step(
                      title: const Text('Submitted'),
                      content: const SizedBox.shrink(),
                      isActive: _currentStep(status) >= 0,
                      state: _currentStep(status) > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Under Review'),
                      content: const SizedBox.shrink(),
                      isActive: _currentStep(status) >= 1,
                      state: _currentStep(status) > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Verified'),
                      content: const SizedBox.shrink(),
                      isActive: _currentStep(status) >= 2,
                      state: status == 'Rejected'
                          ? StepState.error
                          : _currentStep(status) > 2
                              ? StepState.complete
                              : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Completed'),
                      content: const SizedBox.shrink(),
                      isActive: _currentStep(status) >= 3,
                      state: _currentStep(status) == 3
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Application Details
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Submitted: ${submissionDate.month}/${submissionDate.day}/${submissionDate.year}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number, size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Application ID: $applicationId'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.directions_bike, size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Franchise Type: $franchiseType'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Rejection Reason
              if (status == 'Rejected')
                Card(
                  color: AppColors.errorLight,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Reason for rejection: $rejectionReason',
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 