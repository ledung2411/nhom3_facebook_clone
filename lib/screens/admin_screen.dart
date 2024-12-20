import 'package:bt_nhom3/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Clear stored credentials (JWT token)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, Admin!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
