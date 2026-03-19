import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todoapp/auth/auth_service.dart';
import 'package:todoapp/auth/login_screen.dart' show LoginScreen;
import 'package:todoapp/auth/signup_screen.dart' show SignupScreen;
import 'package:todoapp/dashboard/dashboard_screen.dart';
import 'package:todoapp/services/supabase_service.dart';
import 'app/theme.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ojdjzuhcwgdfnrnnavbf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qZGp6dWhjd2dkZm5ybm5hdmJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MTI3MTcsImV4cCI6MjA4OTQ4ODcxN30.EPGNI-U4MTPEm6rrzB6PVzdF3gW_O7P-Kdcz32gtOrA'
  );
  
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SupabaseService()),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
      ],
      child: Consumer2<AuthService, ThemeModeProvider>(
        builder: (context, auth, themeProvider, _) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: auth.isLoggedIn ? '/dashboard' : '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/signup': (context) => SignupScreen(),
              '/dashboard': (context) => DashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
