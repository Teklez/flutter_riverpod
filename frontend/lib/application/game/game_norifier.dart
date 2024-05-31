
import 'package:frontend/domain/game_model.dart';
import 'package:frontend/infrastructure/game/game_repository.dart';
import 'package:frontend/presentation/events/game_events.dart';
import 'package:frontend/presentation/states/game_states.dart';
import 'package:riverpod/riverpod.dart';



class GameNotifier extends StateNotifier<GameState> {
  final GameRepository gameRepository;

  GameNotifier({required this.gameRepository}) : super(GameInitial()) {
    // Register event handlers
  }

  Future<void> handleFetchGames(FetchGames event) async {
    try {
      final List<Game> games = await gameRepository.fetchGames();
      if (games.isEmpty) {
        state = GameEmpty();
        return;
      } else {
        state = GameLoadSuccess(games);
      }
    } catch (e) {
      throw Exception('Error fetching games: $e');
    }
  }

  Future<void> handleAddGame(AddGame event) async {
    try {
      await gameRepository.addGame(event.game);
      final List<Game> games = await gameRepository.fetchGames();
      state = GameLoadSuccess(games);
    } catch (e) {
      state = GameError();
    }
  }

  Future<void> handleEditGame(EditGame event) async {
    try {
      await gameRepository.editGame(event.game);
      final List<Game> games = await gameRepository.fetchGames();
      state = GameLoadSuccess(games);
    } catch (e) {
      state = GameError();
    }
  }

  Future<void> handleDeleteGame(DeleteGame event) async {
    try {
      await gameRepository.deleteGame(event.gameId);
      final List<Game> games = await gameRepository.fetchGames();
      state = GameLoadSuccess(games);
    } catch (e) {
      state = GameError();
    }
  }
}
