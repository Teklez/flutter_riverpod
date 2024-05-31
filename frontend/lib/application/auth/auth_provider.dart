
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/auth/auth_notifier.dart';
import 'package:frontend/infrastructure/auth/auth_repository.dart';

import '../../infrastructure/auth/auth_service.dart';
import '../../presentation/states/auth_state.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(authService: AuthService());
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository: authRepository);
});
