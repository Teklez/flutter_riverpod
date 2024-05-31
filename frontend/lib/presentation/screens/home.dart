import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/game/game_provider.dart';
import 'package:frontend/presentation/events/game_events.dart';
import 'package:frontend/presentation/states/game_states.dart';
import 'package:frontend/presentation/widgets/custom_card.dart';
import 'package:frontend/presentation/widgets/drawer.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);

    // Fetch games on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameNotifier.handleFetchGames(const FetchGames());
    });

    final gameState = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 47, 47),
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
        title: const Text(
          "BetEbet",
        ),
      ),
      drawer: const MenuDrawer(
        menuItems: [
          ["Home", "/"],
          ["Profile", "/profile"],
          ["About", "/about"],
          ["Logout", "/login"],
        ],
      ),
      body: Builder(
        builder: (context) {
          if (gameState is GameEmpty) {
            return const Center(child: Text("No games found"));
          } else if (gameState is GameLoadSuccess) {
            return GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 10.0,
              children: gameState.games.map((game) {
                return GameCard(
                  game: game,
                );
              }).toList(),
            );
          } else if (gameState is GameError) {
            return const Center(child: Text("Error loading games"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
