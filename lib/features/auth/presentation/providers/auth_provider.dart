import 'package:flutter/material.dart';
import 'package:restaurant_management_system/features/auth/domain/entities/user.dart';
import 'package:restaurant_management_system/features/auth/domain/usecases/login_usecase.dart';

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
      _currentUser = await _loginUseCase(email, password);
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
