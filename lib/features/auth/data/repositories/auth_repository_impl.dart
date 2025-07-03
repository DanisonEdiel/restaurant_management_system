import 'package:restaurant_management_system/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:restaurant_management_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management_system/features/auth/domain/entities/user.dart';
import 'package:restaurant_management_system/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSource();
  final AuthLocalDataSource localDataSource = AuthLocalDataSource();

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final user = await remoteDataSource.register(name, email, password);
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await localDataSource.clearUser();
      return true;
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final user = await localDataSource.getUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
