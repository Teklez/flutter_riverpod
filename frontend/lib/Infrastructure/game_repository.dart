import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/game_model.dart';
import 'package:frontend/Infrastructure/game_service.dart';

final gameRepositoryProvider = Provider((ref) {
  final container = ProviderContainer();
  final gameService = container.read(gameServiceProvider);
  return GameRepository(gameService);
});

class GameRepository {
  final GameService _gameService;

  GameRepository(this._gameService);

  Future<List<Game>> fetchGames() async {
    try {
      return await _gameService.fetchGames();
    } catch (e) {
      print('Error fetching games: $e');
      throw Exception('Failed to fetch games: $e');
    }
  }

  Future<void> addGame(Game game) async {
    try {
      await _gameService.addGame(game);
    } catch (e) {
      print('Error adding game: $e');
      throw Exception('Failed to add game: $e');
    }
  }

  Future<void> editGame(Game game) async {
    try {
      await _gameService.editGame(game);
    } catch (e) {
      print('Error editing game: $e');
      throw Exception('Failed to edit game: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _gameService.deleteGame(gameId);
    } catch (e) {
      print('Error deleting game: $e');
      throw Exception('Failed to delete game: $e');
    }
  }
}
