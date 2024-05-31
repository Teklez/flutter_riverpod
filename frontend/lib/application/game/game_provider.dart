import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/game/game_norifier.dart';
import 'package:frontend/infrastructure/game/game_repository.dart';
import 'package:frontend/infrastructure/game/game_service.dart';
import 'package:frontend/presentation/states/game_states.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(gameService: GameService());
});

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  final gameRepository = ref.read(gameRepositoryProvider);
  return GameNotifier(gameRepository: gameRepository);
});
