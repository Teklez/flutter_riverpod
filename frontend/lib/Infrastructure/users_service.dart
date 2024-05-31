import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Domain/users_model.dart';

final usersServiceProvider = Provider<UsersService>((ref) {
  return UsersService();
});

class UsersService {
  static const baseUrl = 'http://127.0.0.1:5500';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/auth/users'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  Future<void> changeStatus(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/update/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change status');
    }
  }
}
