import 'dart:convert';
import 'package:bt_nhom3/env.dart';
import 'package:bt_nhom3/api/api_client.dart';
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
}

class ApiClient {
  final String baseUrl;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? Env.baseUrl;

  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
    );
  }

  Future<http.Response> post(String endpoint, {Map<String, String>? headers, dynamic body}) {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, {Map<String, String>? headers, dynamic body}) {
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) {
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
    );
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    return {
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    };
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
      var response = await _apiClient.post('Authenticate/register', body: body);

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
