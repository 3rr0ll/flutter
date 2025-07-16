import 'package:flutter/material.dart';
import 'dart:math';
import 'app_colors.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  // Mock data
  final String applicationId = 'FT-2023-1234';
  final String franchiseType = 'New';
  final double amountDue = 1500.00;
  final String dueDate = 'Dec 31, 2024';
  String status = 'Pending';

  int _selectedMethod = 0;
  bool _loading = false;
  bool _showSuccess = false;
  String? _transactionId;

  // Payment form controllers
  final _cardNumberController = TextEditingController();
  final _expController = TextEditingController();
  final _cvvController = TextEditingController();
  final _refNoController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expController.dispose();
    _cvvController.dispose();
    _refNoController.dispose();
    super.dispose();
  }

  void _payNow() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
      _showSuccess = true;
      _transactionId = 'TXN${Random().nextInt(99999999).toString().padLeft(8, '0')}';
      status = 'Paid';
    });
  }

  Widget _paymentMethodCard(int index, String label, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = index),
        child: Card(
          elevation: _selectedMethod == index ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _selectedMethod == index ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: _selectedMethod == index ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: _selectedMethod == index ? AppColors.primary : AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedMethod) {
      case 1: // Card
        return Column(
          children: [
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                labelStyle: TextStyle(color: AppColors.textSecondary),
                prefixIconColor: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      prefixIcon: Icon(Icons.date_range, color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIconColor: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: Icon(Icons.lock, color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIconColor: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 2: // Bank Transfer
        return TextFormField(
          controller: _refNoController,
          decoration: InputDecoration(
            labelText: 'Reference No.',
            prefixIcon: Icon(Icons.receipt_long, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIconColor: AppColors.textSecondary,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.primary,
        leading: BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Payment Summary
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
                            Icon(Icons.receipt_long, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text('Application ID: $applicationId', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.directions_bike, color: AppColors.secondary),
                            const SizedBox(width: 8),
                            Text('Franchise Type: $franchiseType', style: TextStyle(color: AppColors.textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: AppColors.success),
                            const SizedBox(width: 8),
                            Text('Amount Due: ₱${amountDue.toStringAsFixed(2)}', style: TextStyle(color: AppColors.textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Text('Due Date: $dueDate', style: TextStyle(color: AppColors.textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              status == 'Paid' ? Icons.check_circle : Icons.pending,
                              color: status == 'Paid' ? AppColors.success : AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Text('Status: $status', style: TextStyle(color: AppColors.textPrimary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Payment Method
                Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _paymentMethodCard(0, 'GCash', Icons.account_balance_wallet),
                    const SizedBox(width: 8),
                    _paymentMethodCard(1, 'Card', Icons.credit_card),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _paymentMethodCard(2, 'Bank Transfer', Icons.account_balance),
                    const SizedBox(width: 8),
                    _paymentMethodCard(3, 'PayMaya', Icons.payment),
                  ],
                ),
                const SizedBox(height: 20),
                // Payment Form
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildPaymentForm(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _loading || status == 'Paid' ? null : _payNow,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          if (_showSuccess)
            _buildSuccessModal(context),
        ],
      ),
    );
  }

  Widget _buildSuccessModal(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, color: AppColors.success, size: 64),
                ),
                const SizedBox(height: 20),
                Text('Payment Successful!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Text('Transaction ID: $_transactionId', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Mock download
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Receipt downloaded (mock)', style: TextStyle(color: AppColors.textPrimary))));
                  },
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text('Download Receipt', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => setState(() => _showSuccess = false),
                  child: Text('Close', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 