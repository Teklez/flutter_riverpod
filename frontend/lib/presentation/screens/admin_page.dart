import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/game/game_provider.dart';
import 'package:frontend/presentation/events/game_events.dart';
import 'package:frontend/presentation/states/game_states.dart';
import 'package:frontend/presentation/widgets/custom_card.dart';
import 'package:frontend/presentation/widgets/drawer.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);

    // Trigger fetching games when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameNotifier.handleFetchGames(const FetchGames());
    });

    final gameState = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 47, 47),
        title: const Text("BetEbet"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              context.push('/search');
            },
          ),
        ],
      ),
      drawer: const MenuDrawer(
        menuItems: [
          ["Home", "/admin"],
          ["Users", "/users"],
          ["Profile", "/profile"],
          ["Add Game", "/add_game"],
          ["Logout", "/login"]
        ],
      ),
      body: Builder(
        builder: (context) {
          if (gameState is GameEmpty) {
            return const Center(child: Text("No games found"));
          } else if (gameState is GameLoadSuccess) {
            return GridView.count(
              crossAxisCount: 1,
              padding: const EdgeInsets.all(20.0),
              childAspectRatio: 8.0 / 10.0,
              children: gameState.games.map((game) {
                return AGameCard(
                  game: game,
                );
              }).toList(),
            );
          } else if (gameState is GameError) {
            return const Center(child: Icon(Icons.error));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
