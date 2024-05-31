import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/widgets/dialogues.dart';
import 'package:frontend/presentation/widgets/drawer.dart';
import 'package:frontend/Domain/users_state.dart';
import 'package:frontend/Application/users_bloc.dart';
import 'package:frontend/Application/users_event.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBloc = ref.watch(usersBlocProvider.notifier);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userBloc.add(const FetchUsers());
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 47, 47),
        title: const Text("BetEbet"),
      ),
      drawer: const MenuDrawer(
        menuItems: [
          ["Home", '/admin'],
          ["Users", '/users'],
          ["Profile", '/profile'],
          ["Add Game", '/add_game'],
          ["Logout", '/login']
        ],
      ),
      body: ref.watch(usersBlocProvider).when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text("Error loading users")),
            data: (state) {
              if (state is UsersEmpty) {
                return const Center(child: Text("No users found"));
              } else if (state is UsersLoadSuccess) {
                return ListView(
                  children: _buildUserCard(state.users),
                );
              }
              return Container(); // Return an empty container for other states
            },
          ),
    );
  }

  List<Card> _buildUserCard(users) {
    List<Card> cards = [];
    for (var i = 0; i < users.length; i++) {
      var card = Card(
        child: ListTile(
          leading: Icon(Icons.person, color: Color.fromARGB(255, 211, 47, 47)),
          title: Text(users[i].username),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Role: ${users[i].roles}"),
              Text("Status: ${users[i].status}"),
            ],
          ),
          trailing: BlockRole(user: users[i]),
        ),
      );
      cards.add(card);
    }
    return cards;
  }
}
