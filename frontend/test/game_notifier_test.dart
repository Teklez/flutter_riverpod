import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/game/game_norifier.dart';
import 'package:frontend/application/game/game_provider.dart';
import 'package:frontend/domain/game_model.dart';
import 'package:frontend/infrastructure/game/game_repository.dart';
import 'package:frontend/presentation/events/game_events.dart';
import 'package:frontend/presentation/states/game_states.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for dependencies
class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late ProviderContainer container;
  late MockGameRepository mockGameRepository;
  late GameNotifier gameNotifier;

  setUp(() {
    // Setting up the mock repository and provider container
    mockGameRepository = MockGameRepository();
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(mockGameRepository),
      ],
    );
    gameNotifier = container.read(gameProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('gameProvider should handle fetch games successfully', () async {
    final games = [
      Game(id: '1', name: 'Game 1', image: 'image1.png'),
      Game(id: '2', name: 'Game 2', image: 'image2.png'),
    ];

    when(() => mockGameRepository.fetchGames()).thenAnswer((_) async => games);
    expect(container.read(gameProvider), GameInitial());

    await gameNotifier.handleFetchGames(FetchGames());

    expect(container.read(gameProvider), isA<GameLoadSuccess>());
    expect((container.read(gameProvider) as GameLoadSuccess).games, games);
  });

  test('gameProvider should handle fetch games with no results', () async {
    when(() => mockGameRepository.fetchGames()).thenAnswer((_) async => []);
    expect(container.read(gameProvider), GameInitial());

    await gameNotifier.handleFetchGames(FetchGames());

    expect(container.read(gameProvider), isA<GameEmpty>());
  });

  test('gameProvider should handle add game successfully', () async {
    final newGame = Game(id: '3', name: 'Game 3', image: 'image3.png');
    final games = [
      Game(id: '1', name: 'Game 1', image: 'image1.png'),
      Game(id: '2', name: 'Game 2', image: 'image2.png'),
      newGame,
    ];

    when(() => mockGameRepository.addGame(newGame)).thenAnswer((_) async {});
    when(() => mockGameRepository.fetchGames()).thenAnswer((_) async => games);

    await gameNotifier.handleAddGame(AddGame(newGame));

    expect(container.read(gameProvider), isA<GameLoadSuccess>());
    expect((container.read(gameProvider) as GameLoadSuccess).games, games);
  });

  test('gameProvider should handle edit game successfully', () async {
    final editedGame = Game(id: '1', name: 'Edited Game', image: 'image1.png');
    final games = [
      editedGame,
      Game(id: '2', name: 'Game 2', image: 'image2.png'),
    ];

    when(() => mockGameRepository.editGame(editedGame))
        .thenAnswer((_) async {});
    when(() => mockGameRepository.fetchGames()).thenAnswer((_) async => games);

    await gameNotifier.handleEditGame(EditGame(editedGame));

    expect(container.read(gameProvider), isA<GameLoadSuccess>());
    expect((container.read(gameProvider) as GameLoadSuccess).games, games);
  });

  test('gameProvider should handle delete game successfully', () async {
    final games = [
      Game(id: '2', name: 'Game 2', image: 'image2.png'),
    ];

    when(() => mockGameRepository.deleteGame('1')).thenAnswer((_) async {});
    when(() => mockGameRepository.fetchGames()).thenAnswer((_) async => games);

    await gameNotifier.handleDeleteGame(DeleteGame('1'));

    expect(container.read(gameProvider), isA<GameLoadSuccess>());
    expect((container.read(gameProvider) as GameLoadSuccess).games, games);
  });

  test('gameProvider should handle add game failure', () async {
    final newGame = Game(id: '3', name: 'Game 3', image: 'image3.png');

    when(() => mockGameRepository.addGame(newGame))
        .thenThrow(Exception('Failed to add game'));
    expect(container.read(gameProvider), GameInitial());

    await gameNotifier.handleAddGame(AddGame(newGame));

    expect(container.read(gameProvider), isA<GameError>());
  });

  test('gameProvider should handle edit game failure', () async {
    final editedGame = Game(id: '1', name: 'Edited Game', image: 'image1.png');

    when(() => mockGameRepository.editGame(editedGame))
        .thenThrow(Exception('Failed to edit game'));
    expect(container.read(gameProvider), GameInitial());

    await gameNotifier.handleEditGame(EditGame(editedGame));

    expect(container.read(gameProvider), isA<GameError>());
  });

  test('gameProvider should handle delete game failure', () async {
    when(() => mockGameRepository.deleteGame('1'))
        .thenThrow(Exception('Failed to delete game'));
    expect(container.read(gameProvider), GameInitial());

    await gameNotifier.handleDeleteGame(DeleteGame('1'));

    expect(container.read(gameProvider), isA<GameError>());
  });
}
