import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Infrastructure/auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepository(authService: authService);
});

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future login(String username, String password) async {
    return await authService.login(username, password);
  }

  Future<void> logout(message) async {
    return await authService.logout(message);
  }

  Future register(String username, String password) async {
    return await authService.register(username, password);
  }

  Future<String> update(String id, String username, String newPassword,
      String oldPassword) async {
    return await authService.update(id, username, newPassword, oldPassword);
  }

  Future<void> delete(String id) async {
    return await authService.delete(id);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await authService.getCurrentUserFromStoredToken();
  }
}
