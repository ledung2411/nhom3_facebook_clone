import 'dart:convert';
import 'package:bt_nhom3/env.dart';
import 'package:bt_nhom3/api/api_client.dart';
import 'package:bt_nhom3/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  // API login endpoint
  String get apiUrl => "${Env.baseUrl}/Authenticate/login";

  // Secure Storage instance
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  /// Method to handle user login
  ///
  /// Takes [username] and [password] as parameters.
  /// Returns a map containing success status, token, and decoded token information on success, or an error message on failure.
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // Send POST request to API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      // Check if response status is OK
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check the status from the response
        bool status = data['status'];
        if (!status) {
          return {
            "success": false,
            "message": data['message'],
          };
        }

        // Extract and decode the token
        String token = data['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Save token in Secure Storage
        await secureStorage.write(key: 'jwt_token', value: token);

        // Return success response
        return {
          "success": true,
          "token": token,
          "decodedToken": decodedToken,
        };
      } else {
        // Handle non-200 HTTP responses
        return {
          "success": false,
          "message": "Failed to login: ${response.statusCode}",
        };
      }
    } catch (e) {
      // Handle any network or parsing errors
      return {
        "success": false,
        "message": "Network error: $e",
      };
    }
  }

  /// Method to retrieve JWT token from Secure Storage
  Future<String?> getToken() async {
    try {
      return await secureStorage.read(key: 'jwt_token');
    } catch (e) {
      return null;
    }
  }

  /// Method to log out the user by clearing the stored token
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: 'jwt_token');
    } catch (e) {
      // Handle storage deletion errors
      rethrow;
    }
  }
}

class Auth {
  static final AuthService _authService = AuthService();
  static final ApiClient _apiClient = ApiClient();

  /// Login method using [AuthService]
  static Future<Map<String, dynamic>> login(String username, String password) async {
    var result = await _authService.login(username, password);
    return result; // returns a map with {success: bool, token: string?, role: string?, message: string?}
  }

  /// Register a new account
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String initials,
    required String role,
  }) async {
    // Create request body
    Map<String, dynamic> body = {
      "username": username,
      "email": email,
      "password": password,
      "initials": initials,
      "role": role,
    };

    // Call API to register via ApiClient
    try {
      var response = await _apiClient.post('/Authenticate/register', body: body);

      // Handle API response
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      } else {
        return {
          'success': false,
          'message': 'Registration failed, please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    // Clear stored credentials (JWT token)
    await secureStorage.delete(key: 'jwt_token');

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
