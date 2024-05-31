import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/game_model.dart';
import 'package:frontend/Domain/game_states.dart';
import '../Infrastructure/game_repository.dart';

final gameBlocProvider = StateNotifierProvider((ref) {
  final container = ProviderContainer();
  final gameRepository = container.read(gameRepositoryProvider);
  return GameBloc(gameRepository);
});

class GameBloc extends StateNotifier<GameState> {
  final GameRepository _gameRepository;

  GameBloc(this._gameRepository) : super(GameInitial()) {
    // Fetch games initially
    fetchGames();
  }

  Future<void> fetchGames() async {
    state = GameLoading();
    try {
      final List<Game> games = await _gameRepository.fetchGames();
      if (games.isEmpty) {
        state = GameEmpty();
      } else {
        state = GameLoadSuccess(games);
      }
    } catch (e) {
      print(e.toString());
      state = GameError();
    }
  }

  Future<void> addGame(Game game) async {
    try {
      await _gameRepository.addGame(game);
      fetchGames();
    } catch (e) {
      state = GameError();
    }
  }

  Future<void> editGame(Game game) async {
    try {
      await _gameRepository.editGame(game);
      fetchGames();
    } catch (e) {
      state = GameError();
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _gameRepository.deleteGame(gameId);
      fetchGames();
    } catch (e) {
      state = GameError();
    }
  }
}
