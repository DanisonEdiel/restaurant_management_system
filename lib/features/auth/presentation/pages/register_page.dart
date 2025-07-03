import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management_system/core/navigation/app_router.dart';
import 'package:restaurant_management_system/core/theme/app_theme.dart';
import 'package:restaurant_management_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurant_management_system/features/auth/presentation/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement registration logic
      // For now, just navigate to login page
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or App Name
                  const Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Name Field
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Password Field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Register Button
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
