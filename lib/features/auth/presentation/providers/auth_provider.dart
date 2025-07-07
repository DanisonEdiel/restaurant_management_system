import 'package:flutter/material.dart';
import 'package:restaurant_management_system/features/auth/domain/entities/user.dart';
import 'package:restaurant_management_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  AuthProvider(this._loginUseCase);
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print('AuthProvider: Attempting login with email: $email');
      _currentUser = await _loginUseCase(email, password);
      
      print('AuthProvider: Login successful for user: ${_currentUser?.email}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Login error: $e');
      _isLoading = false;
      
      // Formatear el mensaje de error para que sea más amigable para el usuario
      if (e.toString().contains('Failed to login')) {
        _error = 'Credenciales incorrectas. Por favor, verifica tu email y contraseña.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
        _error = 'No se pudo conectar al servidor. Por favor, verifica tu conexión a internet.';
      } else {
        _error = 'Error de inicio de sesión: ${e.toString()}';
      }
      
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Implement logout logic
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
