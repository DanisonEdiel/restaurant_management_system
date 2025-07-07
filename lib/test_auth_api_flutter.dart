import 'package:flutter/material.dart';
import 'package:restaurant_management_system/features/auth/data/datasources/auth_remote_data_source.dart';

void main() {
  runApp(const TestAuthApp());
}

class TestAuthApp extends StatelessWidget {
  const TestAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Auth API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestAuthPage(),
    );
  }
}

class TestAuthPage extends StatefulWidget {
  const TestAuthPage({super.key});

  @override
  State<TestAuthPage> createState() => _TestAuthPageState();
}

class _TestAuthPageState extends State<TestAuthPage> {
  final AuthRemoteDataSource _authDataSource = AuthRemoteDataSource();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  
  String _responseText = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _checkHealth() async {
    setState(() {
      _isLoading = true;
      _responseText = 'Checking health...';
    });

    try {
      final result = await _authDataSource.checkHealth();
      setState(() {
        _responseText = 'Health check result: $result';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Health check error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _responseText = 'Please enter email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _responseText = 'Logging in...';
    });

    try {
      final user = await _authDataSource.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      final token = await _authDataSource.getAuthToken();
      
      setState(() {
        _responseText = 'Login successful!\nUser: ${user.email}\nToken: $token';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Login error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    if (_fullNameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      setState(() {
        _responseText = 'Please enter full name, email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _responseText = 'Registering...';
    });

    try {
      final user = await _authDataSource.register(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      setState(() {
        _responseText = 'Registration successful!\nUser: ${user.email}';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Registration error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Auth API'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkHealth,
              child: const Text('Check Health'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: const Text('Register'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SelectableText(
                      _responseText,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
