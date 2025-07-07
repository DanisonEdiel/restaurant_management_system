import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final String baseUrl = 'http://auth-lb-1956198723.us-east-1.elb.amazonaws.com:8000';
  
  // Test health check
  print('Testing health check...');
  await checkHealth(baseUrl);
  
  // Test login with form data
  print('\nTesting login with form data...');
  await loginWithFormData(baseUrl, 'test@gmail.com', 'test1234');
  
  // Test login with JSON
  print('\nTesting login with JSON...');
  await loginWithJson(baseUrl, 'test@gmail.com', 'test1234');
  
  // Test registration
  print('\nTesting registration...');
  await register(baseUrl, 'Edison Llano', 'test@gmail.com', 'test1234');
}

Future<void> checkHealth(String baseUrl) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/auth/health'));
    
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('Health check successful!');
    } else {
      print('Health check failed!');
    }
  } catch (e) {
    print('Health check exception: $e');
  }
}

Future<void> loginWithFormData(String baseUrl, String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );
    
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('Login successful!');
    } else {
      print('Login failed!');
    }
  } catch (e) {
    print('Login exception: $e');
  }
}

Future<void> loginWithJson(String baseUrl, String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('Login successful!');
    } else {
      print('Login failed!');
    }
  } catch (e) {
    print('Login exception: $e');
  }
}

Future<void> register(String baseUrl, String fullName, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
      }),
    );
    
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Registration successful!');
    } else {
      print('Registration failed!');
    }
  } catch (e) {
    print('Registration exception: $e');
  }
}
