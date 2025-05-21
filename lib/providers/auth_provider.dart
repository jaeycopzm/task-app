import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = true; // Always authenticated for development
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get token => 'dummy_token';

  Future<bool> login(String username, String password) async {
    return true; // Always succeed
  }

  Future<bool> register(String username, String password) async {
    return true; // Always succeed
  }

  void logout() {
    // No-op for now
  }
}