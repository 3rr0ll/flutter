// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'app_colors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Mock user data
  String _fullName = 'Juan Dela Cruz';
  String _email = 'juan@email.com';
  String _phone = '09171234567';
  String _address = '123 Main St, Barangay Uno, City';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGold),
        titleTextStyle: const TextStyle(
          color: AppColors.primaryGold,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with gold border and initials
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGold, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryNavy.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.accentPurple.withOpacity(0.08),
                  child: Text(
                    _fullName.isNotEmpty
                        ? _fullName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 36,
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _email,
              style: const TextStyle(
                color: AppColors.accentPurple,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            // Profile Form Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _profileField(
                        label: 'Full Name',
                        value: _fullName,
                        enabled: _isEditing,
                        icon: Icons.person,
                        onChanged: (val) => setState(() => _fullName = val),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      _profileField(
                        label: 'Email Address',
                        value: _email,
                        enabled: _isEditing,
                        icon: Icons.email,
                        onChanged: (val) => setState(() => _email = val),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _profileField(
                        label: 'Phone Number',
                        value: _phone,
                        enabled: _isEditing,
                        icon: Icons.phone,
                        onChanged: (val) => setState(() => _phone = val),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _profileField(
                        label: 'Address',
                        value: _address,
                        enabled: _isEditing,
                        icon: Icons.home,
                        onChanged: (val) => setState(() => _address = val),
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Edit/Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(_isEditing ? Icons.save : Icons.edit, color: AppColors.primaryNavy),
                label: Text(
                  _isEditing ? 'Save' : 'Edit',
                  style: const TextStyle(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_isEditing) {
                    setState(() => _isEditing = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Changes saved'),
                        backgroundColor: AppColors.accentGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileField({
    required String label,
    required String value,
    required bool enabled,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      enabled: enabled,
      initialValue: value,
      style: const TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accentPurple),
        labelStyle: const TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.w600),
        filled: true,
        fillColor: enabled ? AppColors.accentPurple.withOpacity(0.06) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accentPurple.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accentPurple.withOpacity(0.3)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
} 