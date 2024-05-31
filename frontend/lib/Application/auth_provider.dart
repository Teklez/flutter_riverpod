import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Infrastructure/auth_service.dart';
import 'auth_event.dart';
import '../Infrastructure/auth_repository.dart';
import '../Domain/auth_state.dart';

final autherviceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepository(authService: authService);
});

final authNotifierProvider = StateNotifierProvider<Auth, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return Auth(authRepository);
});

class Auth extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  Auth(this.authRepository) : super(AuthInitial());

  void handleCurrentUser(CurrentUser event) async {
    try {
      final user = await authRepository.getCurrentUser();
      state = AuthSuccess(message: user);
    } catch (e) {
      state = AuthFailure(message: 'Not authenticated');
    }
  }

  void handleAppStarted(AppStarted event) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        state = AuthSuccess(message: user);
      } else {
        state = AuthFailure(message: 'Not authenticated');
      }
    } catch (e) {
      state = AuthFailure(message: 'Not authenticated');
    }
  }

  void handleUserLoggedIn(UserLoggedIn event) async {
    try {
      final token = await authRepository.login(event.username, event.password);
      if (token != null) {
        state = AuthSuccess(message: token);
      } else {
        state = AuthFailure(message: 'Not authenticated');
      }
    } catch (e) {
      if (e.toString().contains('IncorrectPassword')) {
        state = AuthFailure(message: 'Incorrect password');
      } else {
        state = AuthFailure(message: 'User name or password is incorrect');
      }
    }
  }

  void handleUserLoggedOut(UserLoggedOut event) async {
    try {
      await authRepository.logout(event.message);
      state = AuthFailure(message: 'Logged out successfully');
    } catch (e) {
      state = AuthFailure(message: 'Failed to logout');
    }
  }

  void handleUserRegistered(UserRegistered event) async {
    try {
      final user =
          await authRepository.register(event.username, event.password);
      if (user != null) {
        state = AuthSuccess(message: user);
      } else {
        state = AuthFailure(message: 'null returned from register user');
      }
    } catch (e) {
      if (e.toString().contains('userAlreadyExists')) {
        state = AuthFailure(message: 'User Name is already taken');
      } else {
        state = AuthFailure(message: 'Failed to register user');
      }
    }
  }

  void handleUserDeleted(UserDeleted event) async {
    try {
      await authRepository.delete(event.id);
    } catch (e) {
      state = AuthFailure(message: "Failed to delete user");
    }
  }

  void handleUserUpdated(UserUpdated event) async {
    try {
      final data = await authRepository.update(
          event.id, event.username, event.newPassword, event.oldPassword);

      if (data != null) {
        state = UpdateSuccess(message: "Profile updated");
      } else {
        state = AuthFailure(message: 'update failed');
      }
    } catch (e) {
      state = AuthFailure(message: '');
    }
  }
}
