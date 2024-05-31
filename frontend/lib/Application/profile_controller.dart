import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/profile_state.dart';
import 'package:frontend/Infrastructure/auth_service.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ProfileController(authService);
});

class ProfileController extends StateNotifier<ProfileState> {
  final AuthService authService;

  ProfileController(this.authService) : super(ProfileLoading());

  void fetchCurrentUser() async {
    try {
      final user = await authService.getCurrentUser();
      state = ProfileLoadSuccess(user);
    } catch (e) {
      state = ProfileLoadFailure('Failed to load user');
    }
  }

  void updateUser(String id, String username, String oldPassword,
      String newPassword) async {
    try {
      final updatedUser = await authService.updateUser(
          id: id,
          username: username,
          oldPassword: oldPassword,
          newPassword: newPassword);
      state = ProfileUpdateSuccess(updatedUser);
    } catch (e) {
      state = ProfileUpdateFailure('Failed to update user');
    }
  }

  void deleteUser(String id) async {
    try {
      await authService.deleteUser(id);
      state = ProfileDeleteSuccess('User deleted successfully');
    } catch (e) {
      state = ProfileDeleteFailure('Failed to delete user');
    }
  }
}
