// lib/api/auth_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../env.dart';
import '../models/auth_model.dart';

class AuthApi {
  final String baseUrl = "${Env.baseUrl}/Authenticate";
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(data);

        if (authResponse.status && authResponse.token != null) {
          await storage.write(key: 'jwt_token', value: authResponse.token);
        }

        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}