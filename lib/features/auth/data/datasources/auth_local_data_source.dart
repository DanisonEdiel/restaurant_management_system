import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_management_system/features/auth/data/models/user_model.dart';
import 'package:restaurant_management_system/features/auth/domain/entities/user.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _userKey = 'user_data';
  final String _tokenKey = 'auth_token';

  Future<void> saveUser(User user) async {
    if (user is UserModel) {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    }
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<User?> getUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> clearUser() async {
    await _secureStorage.delete(key: _userKey);
    await _secureStorage.delete(key: _tokenKey);
  }
}
