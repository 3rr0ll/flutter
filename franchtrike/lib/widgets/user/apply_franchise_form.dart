import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'user_dashboard.dart';
import 'app_colors.dart';

class ApplyFranchiseForm extends StatefulWidget {
  const ApplyFranchiseForm({super.key});

  @override
  State<ApplyFranchiseForm> createState() => _ApplyFranchiseFormState();
}

class _ApplyFranchiseFormState extends State<ApplyFranchiseForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _plateController = TextEditingController();
  File? _validIdFile;
  File? _orcrFile;
  bool _agreed = false;
  bool _loading = false;
  late AnimationController _btnController;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(bool isId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isId) {
          _validIdFile = File(picked.path);
        } else {
          _orcrFile = File(picked.path);
        }
      });
    }
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() == true &&
        /* _validIdFile != null &&
        _orcrFile != null && */
        _agreed;
  }

  void _submit() async {
    if (!_isFormValid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Application Submitted Successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const UserDashboard()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    _formKey.currentState?.reset();
    setState(() {
      _validIdFile = null;
      _orcrFile = null;
      _agreed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Franchise Application', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryNavy,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Contact Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final phone = v.trim();
                          if (phone.length != 11 || int.tryParse(phone) == null) {
                            return 'Enter 11 digit number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (!v.contains('@')) {
                            return 'Email must contain @';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _plateController,
                        decoration: const InputDecoration(
                          labelText: 'Tricycle Plate Number',
                          prefixIcon: Icon(Icons.confirmation_number),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Upload Documents',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () => _pickFile(true),
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload Valid ID'),
                          ),
                          const SizedBox(width: 12),
                          if (_validIdFile != null)
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Image.file(_validIdFile!, fit: BoxFit.cover),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () => _pickFile(false),
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload OR/CR'),
                          ),
                          const SizedBox(width: 12),
                          if (_orcrFile != null)
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Image.file(_orcrFile!, fit: BoxFit.cover),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                    activeColor: AppColors.primary,
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to the Terms and Conditions',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _btnController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 - _btnController.value,
                    child: child,
                  );
                },
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isFormValid && !_loading
                        ? () async {
                            await _btnController.forward();
                            await _btnController.reverse();
                            _submit();
                          }
                        : null,
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Submit Application',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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