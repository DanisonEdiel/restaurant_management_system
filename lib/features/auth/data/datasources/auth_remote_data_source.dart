import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_management_system/features/auth/data/models/user_model.dart';
import 'package:restaurant_management_system/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'http://auth-lb-1956198723.us-east-1.elb.amazonaws.com:8000';
  
  // Token storage key
  static const String _tokenKey = 'auth_token';
  
  Future<User> login(String email, String password) async {
    try {
      print('Login request to: $baseUrl/auth/login');
      print('Request body: email=$email, password=$password');
      
      // Usar form-data en lugar de JSON ya que la API lo requiere así
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email, // La API espera 'username' aunque enviemos un email
          'password': password,
        },
      );
      
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Guardar el token de acceso
        if (data.containsKey('access_token')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, data['access_token']);
        }
        
        // Como la API solo devuelve el token, creamos un usuario con la información disponible
        return UserModel(
          id: '', // No tenemos ID del usuario en la respuesta
          name: '', // No tenemos nombre del usuario en la respuesta
          email: email,
          role: 'user', // Rol por defecto
          profileImage: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Login exception: $e');
      throw Exception('Login error: $e');
    }
  }
  
  Future<User> register(String fullName, String email, String password) async {
    try {
      print('Registration request to: $baseUrl/auth/signup');
      print('Request body: {"email": "$email", "password": "$password", "full_name": "$fullName"}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
        }),
      );
      
      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Después de un registro exitoso, hacemos login automáticamente
        return await login(email, password);
      } else {
        throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Registration exception: $e');
      throw Exception('Registration error: $e');
    }
  }
  
  Future<bool> resetPassword(String email) async {
    try {
      print('Password reset request to: $baseUrl/auth/reset-password');
      print('Request body: {"email": "$email"}');
      
      // Nota: Este endpoint puede no estar disponible en la API actual
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );
      
      print('Password reset response status: ${response.statusCode}');
      print('Password reset response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to request password reset: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Password reset exception: $e');
      throw Exception('Password reset error: $e');
    }
  }
  
  Future<bool> checkHealth() async {
    try {
      print('Health check request to: $baseUrl/auth/health');
      
      final response = await http.get(Uri.parse('$baseUrl/auth/health'));
      
      print('Health check response status: ${response.statusCode}');
      print('Health check response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Health check exception: $e');
      return false;
    }
  }
  
  // Método para obtener el token almacenado
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Método para limpiar el token (logout)
  Future<bool> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_tokenKey);
  }
}
