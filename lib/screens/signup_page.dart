import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../parking_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final Color _primaryGreen = const Color(0xFF14C8A1);
  final Color _accentYellow = const Color(0xFFFFE081);
  static const int _minPasswordLength = 8;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    final auth = context.read<AuthProvider>();
    if (!_formKey.currentState!.validate()) return;

    final success = await auth.signup(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      passwordConfirm: _confirmPasswordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );

    if (!mounted) return;

    if (success) {
      // After successful signup, go back to the login page.
      Navigator.of(context).pop();
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome to Parking',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _primaryGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create an account to book your parking slots.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _TextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person,
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Enter username' : null,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      controller: _firstNameController,
                      label: 'First name',
                      icon: Icons.badge,
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Enter first name' : null,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      controller: _lastNameController,
                      label: 'Last name',
                      icon: Icons.badge_outlined,
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Enter last name' : null,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          (val == null || !val.contains('@')) ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (val) {
                        final v = val ?? '';
                        if (v.isEmpty) return 'Enter password';
                        if (v.length < _minPasswordLength) {
                          return 'Must be at least $_minPasswordLength characters';
                        }
                        final isAllDigits = RegExp(r'^\d+$').hasMatch(v);
                        if (isAllDigits) {
                          return 'Password can’t be numbers only';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password rules:\n'
                        '- At least $_minPasswordLength characters\n'
                        '- Not numbers only\n'
                        '- Avoid common passwords (e.g. 12345678)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Confirm your password';
                        }
                        if (val != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    if (auth.errorMessage != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          auth.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: auth.isLoading ? null : _onSignup,
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Already have an account? Log in',
                style: TextStyle(color: _accentYellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF14C8A1)),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}


