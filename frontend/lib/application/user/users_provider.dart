import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/user/users_notifier.dart';

import 'package:frontend/infrastructure/user/users_repository.dart';
import 'package:frontend/infrastructure/user/users_service.dart';
import 'package:frontend/presentation/states/users_state.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(userService: UsersService());
});

final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final usersRepository = ref.read(usersRepositoryProvider);
  return UsersNotifier(usersRepository: usersRepository);
});
