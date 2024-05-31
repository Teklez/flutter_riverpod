import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/users_model.dart';

abstract class UsersState extends Equatable {
  const UsersState();
}

class UsersInitial extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersLoadSuccess extends UsersState {
  final List<User> users;

  const UsersLoadSuccess(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersError extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersEmpty extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersLoadInProgress extends UsersState {
  @override
  List<Object?> get props => [];
}

final usersStateNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, UsersState>((ref) {
  return UsersStateNotifier(UsersInitial());
});

class UsersStateNotifier extends StateNotifier<UsersState> {
  UsersStateNotifier(UsersState state) : super(state);

  void loading() {
    state = UsersLoadInProgress();
  }

  void loaded(List<User> users) {
    state = UsersLoadSuccess(users);
  }

  void error() {
    state = UsersError();
  }

  void empty() {
    state = UsersEmpty();
  }
}
