import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/users_model.dart';
import 'package:frontend/Infrastructure/users_service.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final userService = ref.watch(usersServiceProvider);
  return UsersRepository(userService: userService);
});

class UsersRepository {
  final UsersService userService;

  UsersRepository({required this.userService});

  Future<List<User>> fetchUsers() async {
    try {
      return await userService.fetchUsers();
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  Future<void> changeStatus(User user) async {
    try {
      await userService.changeStatus(user);
    } catch (e) {
      print('Error changing status: $e');
      rethrow;
    }
  }
}
