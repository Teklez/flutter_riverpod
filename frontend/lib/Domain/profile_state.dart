import 'package:equatable/equatable.dart';

// Define ProfileState base class and its subclasses

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final Map<String, dynamic> user;

  const ProfileLoadSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileLoadFailure extends ProfileState {
  final String error;

  const ProfileLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileUpdateSuccess extends ProfileState {
  final Map<String, dynamic> user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateFailure extends ProfileState {
  final String error;

  const ProfileUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileDeleteSuccess extends ProfileState {
  final String message;

  const ProfileDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileDeleteFailure extends ProfileState {
  final String error;

  const ProfileDeleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}
