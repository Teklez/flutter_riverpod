import 'package:equatable/equatable.dart';
import 'package:frontend/Domain/game_model.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoadSuccess extends GameState {
  final List<Game> games;

  const GameLoadSuccess(this.games);

  @override
  List<Object?> get props => [games];
}

class GameLoading extends GameState {}

class GameError extends GameState {}

class GameEmpty extends GameState {}
