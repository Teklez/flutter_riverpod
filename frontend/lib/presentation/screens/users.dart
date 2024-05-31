import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/users_model.dart';
import 'package:frontend/presentation/events/users_event.dart';
import 'package:frontend/presentation/widgets/dialogues.dart';
import 'package:frontend/presentation/widgets/drawer.dart';
import 'package:frontend/application/user/users_provider.dart';
import 'package:frontend/presentation/states/users_state.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersNotifier = ref.read(usersProvider.notifier);

    // Trigger fetching users when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usersNotifier.handleFetchUsers(const FetchUsers());
    });

    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        title: const Text("BetEbet"),
      ),
      drawer: const MenuDrawer(menuItems: [
        ["Home", '/admin'],
        ["Users", '/users'],
        ["Profile", '/profile'],
        ["Add Game", '/add_game'],
        ["Logout", '/login']
      ]),
      body: _buildBody(usersState),
    );
  }

  Widget _buildBody(UsersState state) {
    if (state is UsersInitial) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is UsersEmpty) {
      return const Center(child: Text("No users found"));
    } else if (state is UsersLoadSuccess) {
      return ListView(
        children: _buildUserCard(state.users),
      );
    } else if (state is UsersError) {
      return const Center(child: Text("Error loading users"));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  List<Card> _buildUserCard(List<User> users) {
    return users.map((user) {
      return Card(
        child: ListTile(
          leading:
              const Icon(Icons.person, color: Color.fromARGB(255, 211, 47, 47)),
          title: Text(user.username),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Role: ${user.roles}"),
              Text("Status: ${user.status}"),
            ],
          ),
          trailing: BlockRole(user: user),
        ),
      );
    }).toList();
  }
}
