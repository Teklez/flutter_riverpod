import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  String _status;
  String _roles;

  User({
    required this.id,
    required this.username,
    required this.password,
    String roles = 'user',
    String status = 'unblocked',
  })  : _roles = roles,
        _status = status;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      roles: json['roles'][0],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'roles': [_roles],
        'status': _status,
      };

  // Getter for status
  String get status => _status;

  // Setter for status
  set status(String newStatus) {
    _status = newStatus;
  }

  // Getter for roles
  String get roles => _roles;

  // Setter for roles
  set roles(String newRoles) {
    _roles = newRoles;
  }

  @override
  List<Object?> get props => [id, username, password, roles, status];
}
