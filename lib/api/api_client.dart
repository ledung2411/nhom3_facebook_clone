import 'dart:convert';
import 'package:bt_nhom3/env.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Đổi tên từ AuthService thành ApiAuthService
class ApiAuthService {
  String get apiUrl => "${Env.baseUrl}/Authenticate/login";
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!data['status']) {
          return {
            "success": false,
            "message": data['message'],
          };
        }

        String token = data['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        await secureStorage.write(key: 'jwt_token', value: token);

        return {
          "success": true,
          "token": token,
          "decodedToken": decodedToken,
        };
      } else {
        return {
          "success": false,
          "message": "Failed to login: ${response.statusCode}",
        };
      }
    } catch (e) {
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
  static final ApiAuthService _authService = ApiAuthService();
  static final ApiClient _apiClient = ApiClient();

  static Future<Map<String, dynamic>> login(String username, String password) async {
    var result = await _authService.login(username, password);
    return result;
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String initials,
    required String role,
  }) async {
    Map<String, dynamic> body = {
      "username": username,
      "email": email,
      "password": password,
      "initials": initials,
      "role": role,
    };

    try {
      var response = await _apiClient.post('/Authenticate/register', body: body);

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