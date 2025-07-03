import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_management_system/features/auth/data/models/user_model.dart';
import 'package:restaurant_management_system/features/auth/domain/entities/user.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'https://api.restaurantmanagement.com/api';
  
  Future<User> login(String email, String password) async {
    // TODO: Replace with actual API call
    // This is a mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'admin@example.com' && password == 'password123') {
      return UserModel(
        id: '1',
        name: 'Admin User',
        email: email,
        role: 'admin',
        profileImage: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else if (email == 'staff@example.com' && password == 'password123') {
      return UserModel(
        id: '2',
        name: 'Staff User',
        email: email,
        role: 'staff',
        profileImage: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      throw Exception('Invalid credentials');
    }
    
    // Actual implementation would be:
    /*
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Failed to login');
    }
    */
  }
  
  Future<User> register(String name, String email, String password) async {
    // TODO: Replace with actual API call
    // This is a mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return UserModel(
      id: '3',
      name: name,
      email: email,
      role: 'staff',
      profileImage: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Actual implementation would be:
    /*
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Failed to register');
    }
    */
  }
}
