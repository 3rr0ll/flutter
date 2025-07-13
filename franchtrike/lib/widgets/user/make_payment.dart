import 'package:flutter/material.dart';
import 'dart:math';

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
              color: _selectedMethod == index ? Colors.blue : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: _selectedMethod == index ? Colors.blue : Colors.grey),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: _selectedMethod == index ? Colors.blue : Colors.black87)),
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
              decoration: const InputDecoration(
                labelText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'MM/YY',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: Icon(Icons.lock),
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
          decoration: const InputDecoration(
            labelText: 'Reference No.',
            prefixIcon: Icon(Icons.receipt_long),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF5B2C6F);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: themeColor,
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
                            const Icon(Icons.receipt_long, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text('Application ID: $applicationId', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.directions_bike, color: Colors.purple),
                            const SizedBox(width: 8),
                            Text('Franchise Type: $franchiseType'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.attach_money, color: Colors.green),
                            const SizedBox(width: 8),
                            Text('Amount Due: ₱${amountDue.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text('Due Date: $dueDate'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              status == 'Paid' ? Icons.check_circle : Icons.pending,
                              color: status == 'Paid' ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text('Status: $status'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Payment Method
                const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.w600)),
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
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _loading || status == 'Paid' ? null : _payNow,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 64),
                ),
                const SizedBox(height: 20),
                const Text('Payment Successful!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Transaction ID: $_transactionId', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Mock download
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt downloaded (mock)')));
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Receipt'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => setState(() => _showSuccess = false),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 