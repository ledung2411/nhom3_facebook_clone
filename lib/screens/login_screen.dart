import 'dart:convert';
import 'package:bt_nhom3/env.dart';
import 'package:bt_nhom3/api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:bt_nhom3/screens/admin_screen.dart';
import 'package:bt_nhom3/screens/main_screen.dart';
import 'package:bt_nhom3/screens/register_screen.dart';

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkToken(); // Check token on screen load
  }

  // Check token in SecureStorage
  Future<void> _checkToken() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  // Handle login
  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Call Auth.login for authentication
    Map<String, dynamic> result = await Auth.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // Save token in SecureStorage
      final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
      await secureStorage.write(key: 'jwt_token', value: result['token']);

      String role = result['role'] ?? 'User'; // Default role is 'User'

      // Navigate based on user role
      if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      // Show error message
      String errorMessage = result['message'] ?? 'Tên đăng nhập hoặc mật khẩu không đúng';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'facebook',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Số điện thoại hoặc email',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: const Text(
                        'Đăng ký ngay',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
