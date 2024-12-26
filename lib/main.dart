import 'package:flutter/material.dart';
import 'env.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/main_screen.dart';
import 'service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: AuthService.checkAuthState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            final authState = snapshot.data as Map<String, dynamic>;
            if (authState['isAuthenticated'] == true) {
              if (authState['role'] == 'admin') {
                return const AdminScreen();
              }
              return const MainScreen();
            }
          }

          return const LoginScreen();
        },
      ),
    );
  }
}