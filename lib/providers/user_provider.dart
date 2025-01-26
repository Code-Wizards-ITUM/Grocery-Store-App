import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];

  User? get currentUser => _currentUser;

  Future<void> loadUsers() async {
    final String jsonString =
        await rootBundle.loadString('lib/utils/users.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _users = jsonList.map((json) => User.fromJson(json)).toList();
  }
  bool login(String identifier, String password) {
    try {
      final user = _users.firstWhere((user) =>
          (user.username == identifier || user.email == identifier) &&
          user.password == password);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateUser(User updatedUser) {
    if (_currentUser == null) return;

    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
