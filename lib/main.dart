import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme.dart';
import 'auth/auth_service.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'services/supabase_service.dart';


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
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
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
