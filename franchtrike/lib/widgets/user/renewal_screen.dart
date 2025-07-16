// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dart:async';

class RenewalScreen extends StatefulWidget {
  const RenewalScreen({Key? key}) : super(key: key);

  @override
  State<RenewalScreen> createState() => _RenewalScreenState();
}

class _RenewalScreenState extends State<RenewalScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _franchiseIdController = TextEditingController();
  String? _uploadedFileName;
  bool _agreed = false;
  bool _submitting = false;

  // Mock franchise details
  final Map<String, String> _franchiseDetails = {
    'Franchise ID': 'TRIKE-2024-001',
    'Owner': 'Juan Dela Cruz',
    'Vehicle': 'Yamaha Tricycle',
    'Plate No.': 'ABC-1234',
    'Expiry': '09/30/2024',
  };

  void _pickFile() async {
    // Mock file picker
    setState(() {
      _uploadedFileName = 'renewal_document.pdf';
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || !_agreed) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Renewal'),
        content: const Text('Are you sure you want to submit renewal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _submitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Renewal Submitted'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Franchise ID'),
        isActive: _currentStep >= 0,
        content: TextFormField(
          controller: _franchiseIdController,
          decoration: const InputDecoration(
            labelText: 'Franchise ID',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Enter Franchise ID' : null,
        ),
      ),
      Step(
        title: const Text('Upload Document'),
        isActive: _currentStep >= 1,
        content: ListTile(
          leading: const Icon(Icons.upload_file, color: AppColors.primaryNavy),
          title: Text(_uploadedFileName ?? 'No file selected'),
          trailing: ElevatedButton(
            onPressed: _pickFile,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
            child: const Text('Upload'),
          ),
        ),
      ),
      Step(
        title: const Text('Preview'),
        isActive: _currentStep >= 2,
        content: Card(
          color: AppColors.primaryNavy.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _franchiseDetails.entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text('${e.key}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(e.value)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      Step(
        title: const Text('Agreement'),
        isActive: _currentStep >= 3,
        content: Row(
          children: [
            Checkbox(
              value: _agreed,
              activeColor: AppColors.primaryNavy,
              onChanged: (v) => setState(() => _agreed = v ?? false),
            ),
            const Expanded(
              child: Text('I confirm all information is correct'),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Franchise Renewal'),
        backgroundColor: AppColors.primaryNavy,
      ),
      body: _submitting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Stepper(
                    key: ValueKey(_currentStep),
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep < _buildSteps().length - 1) {
                        if (_currentStep == 0 && (_franchiseIdController.text.isEmpty)) return;
                        setState(() => _currentStep++);
                      } else {
                        _submit();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) setState(() => _currentStep--);
                    },
                    controlsBuilder: (context, details) {
                      final isLast = _currentStep == _buildSteps().length - 1;
                      return Row(
                        children: [
                          if (_currentStep > 0)
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back'),
                            ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: isLast
                                ? (_agreed ? _submit : null)
                                : details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryNavy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(isLast ? 'Submit Renewal' : 'Next'),
                          ),
                        ],
                      );
                    },
                    steps: _buildSteps(),
                  ),
                ),
              ),
            ),
    );
  }
} 