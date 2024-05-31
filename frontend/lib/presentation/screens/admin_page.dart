import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/auth_state.dart';
import 'package:frontend/Application/auth_provider.dart';
import 'package:frontend/Domain/game_model.dart';
import 'package:frontend/Domain/users_model.dart';
import 'package:frontend/Domain/users_state.dart';

final gameListProvider =
    StateNotifierProvider<GameListNotifier, List<Game>>((ref) {
  return GameListNotifier();
});

final userListProvider =
    StateNotifierProvider<UserListNotifier, List<User>>((ref) {
  return UserListNotifier();
});

final authStateProvider = StateProvider<AuthState>((ref) => AuthEmpty());

final adminPageProvider = Provider<Widget>((ref) {
  final authState = ref.watch(authStateProvider).state;

  if (authState is AuthSuccess) {
    return AdminPage();
  } else {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
});

class AdminPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final gameList = watch(gameListProvider);
    final userList = watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_game');
            },
            child: Text('Add Game'),
          ),
          SizedBox(height: 20),
          Text(
            'Games',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gameList.length,
              itemBuilder: (context, index) {
                final game = gameList[index];
                return ListTile(
                  title: Text(game.name),
                  subtitle: Text(game.publisher),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/game_details',
                      arguments: game,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Users',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text(user.username),
                  subtitle: Text(user.roles),
                  onTap: () {
                    // Handle user tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameListNotifier extends StateNotifier<List<Game>> {
  GameListNotifier() : super([]);

  void fetchGames() {
    // Fetch games and update state
  }
}

class UserListNotifier extends StateNotifier<List<User>> {
  UserListNotifier() : super([]);

  void fetchUsers() {
    // Fetch users and update state
  }
}
