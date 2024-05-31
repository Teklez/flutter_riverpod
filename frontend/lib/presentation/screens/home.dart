import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Application/game_provider.dart';
import 'package:frontend/Domain/game_model.dart';
import 'package:frontend/presentation/widgets/custom_card.dart';

final gameListProvider = FutureProvider<List<Game>>((ref) async {
  final gameBloc = ref.watch(gameBlocProvider);
  await gameBloc.fetchGames();
  return gameBloc.games;
});

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Consumer(builder: (context, watch, child) {
        final gameListAsync = watch(gameListProvider);
        return gameListAsync.when(
          data: (games) {
            if (games.isEmpty) {
              return Center(child: Text('No games found'));
            } else {
              return GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                childAspectRatio: 8.0 / 10.0,
                children: games.map((game) {
                  return GameCard(game: game);
                }).toList(),
              );
            }
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading games')),
        );
      }),
    );
  }
}
