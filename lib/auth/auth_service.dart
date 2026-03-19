import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLoggedIn = false;

  Future<void> login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    isLoggedIn = response.session != null;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    isLoggedIn = response.session != null;
    notifyListeners();
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    isLoggedIn = false;
    notifyListeners();
  }
}
