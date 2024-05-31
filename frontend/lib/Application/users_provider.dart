import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/users_model.dart';
import 'package:frontend/Infrastructure/users_repository.dart';
import 'package:frontend/Infrastructure/users_service.dart';
import 'package:frontend/Domain/users_state.dart';

final usersServiceProvider = Provider<UsersService>((ref) {
  return UsersService();
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final usersService = ref.watch(usersServiceProvider);
  return UsersRepository(userService: usersService);
});

class UsersBloc extends StateNotifier<UsersState> {
  final UsersRepository usersRepository;

  UsersBloc(this.usersRepository) : super(UsersInitial()) {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await usersRepository.fetchUsers();
      if (users.isEmpty) {
        state = UsersEmpty();
      } else {
        state = UsersLoadSuccess(users);
      }
    } catch (e) {
      print(e.toString());
      state = UsersError();
    }
  }

  Future<void> changeUserStatus(User user) async {
    try {
      await usersRepository.changeStatus(user);
      await _loadUsers();
    } catch (e) {
      state = UsersError();
    }
  }
}

final usersNotifierProvider =
    StateNotifierProvider<UsersBloc, UsersState>((ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  return UsersBloc(usersRepository);
});
