import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/infrastructure/user/users_repository.dart';
import 'package:frontend/presentation/events/users_event.dart';
import 'package:frontend/presentation/states/users_state.dart';

class UsersNotifier extends StateNotifier<UsersState> {
  final UsersRepository usersRepository;

  UsersNotifier({required this.usersRepository}) : super(UsersInitial());

  Future<void> handleFetchUsers(FetchUsers event) async {
    try {
      final users = await usersRepository.fetchUsers();
      if (users.isEmpty) {
        state = UsersEmpty();
        return;
      } else {
        state = UsersLoadSuccess(users);
      }
    } catch (e) {
      print(e.toString());
      state = UsersError();
    }
  }

  Future<void> handleChangeStatus(ChangeStatus event) async {
    try {
      await usersRepository.changeStatus(event.user);
      final users = await usersRepository.fetchUsers();
      state = UsersLoadSuccess(users);
    } catch (e) {
      state = UsersError();
    }
  }
}
