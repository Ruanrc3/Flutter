import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _email;

  String? get email => _email;

  bool login(String email, String senha) {
    if (email.isNotEmpty && senha.isNotEmpty) {
      _email = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _email = null;
    notifyListeners();
  }
}
