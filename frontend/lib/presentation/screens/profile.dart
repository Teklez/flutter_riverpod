import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Application/profile_controller.dart';
import 'package:frontend/Domain/profile_state.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final profileController = context.read(profileControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profileState is ProfileLoading
          ? const Center(child: CircularProgressIndicator())
          : profileState is ProfileLoadSuccess
              ? _buildProfileView(context, profileState.user, profileController)
              : profileState is ProfileLoadFailure
                  ? Center(child: Text(profileState.error))
                  : Container(),
    );
  }

  Widget _buildProfileView(BuildContext context, Map<String, dynamic> user,
      ProfileController profileController) {
    final TextEditingController _usernameController =
        TextEditingController(text: user['username']);
    final TextEditingController _oldPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    bool _isEditing = false;
    String _errorText = '';

    void _toggleEditMode() {
      _isEditing = !_isEditing;
      _errorText = '';
    }

    void _saveProfile() {
      String username = _usernameController.text;
      String oldPassword = _oldPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        _errorText = 'New password and confirm password do not match';
        return;
      }

      if (username.isEmpty ||
          oldPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmPassword.isEmpty) {
        _errorText = 'All fields are required';
        return;
      }

      profileController.updateUser(
          user['id'], username, oldPassword, newPassword);
    }

    void _deleteAccount() {
      profileController.deleteUser(user['id']);
      Navigator.pushNamed(context, '/register');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.account_circle, size: 100),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user['username'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _toggleEditMode,
            child: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
          ),
          if (_isEditing) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            if (_errorText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _errorText,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _deleteAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
