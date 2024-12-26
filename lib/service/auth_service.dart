import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../env.dart';

class AuthService {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Lưu token và role
  static Future<void> saveAuthData(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    var roleField = decodedToken['role'];
    String role;

    if (roleField is String) {
      role = roleField.toLowerCase();
    } else if (roleField is List) {
      role = roleField.isNotEmpty ? roleField[0].toString().toLowerCase() : 'user';
    } else {
      role = 'user';
    }

    await _storage.write(key: 'user_role', value: role);
  }

  // Lấy token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Lấy role
  static Future<String> getUserRole() async {
    return await _storage.read(key: 'user_role') ?? 'user';
  }

  // Kiểm tra trạng thái xác thực
  static Future<Map<String, dynamic>> checkAuthState() async {
    final token = await _storage.read(key: 'jwt_token');
    final role = await _storage.read(key: 'user_role');

    if (token == null || role == null) {
      return {'isAuthenticated': false, 'role': null};
    }

    try {
      if (JwtDecoder.isExpired(token)) {
        await logout();
        return {'isAuthenticated': false, 'role': null};
      }
      return {'isAuthenticated': true, 'role': role};
    } catch (e) {
      await logout();
      return {'isAuthenticated': false, 'role': null};
    }
  }

  // Đăng xuất
  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_role');
  }

  // Smart Auth validation
  static Future<bool> validateLoginAttempt({
    required String username,
    String? deviceId,
    String? ipAddress,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/api/Authenticate/verify-device'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'deviceId': deviceId ?? 'unknown',
          'ipAddress': ipAddress ?? 'unknown',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == true;
      }
      return false;
    } catch (e) {
      print('Smart Auth Error: $e');
      return false;
    }
  }

  static Future<Map<String, String>> getDeviceInfo() async {
    final deviceId = await getDeviceId();
    final ipAddress = await getIpAddress();

    return {
      'deviceId': deviceId ?? 'unknown',
      'ipAddress': ipAddress ?? 'unknown',
    };
  }

  static Future<String?> getDeviceId() async {
    // Implement device ID generation/retrieval logic
    return 'sample-device-id';
  }

  static Future<String?> getIpAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      print('IP Address Error: $e');
      return null;
    }
  }
}