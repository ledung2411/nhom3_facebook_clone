// lib/models/auth_model.dart
class AuthResponse {
  final bool status;
  final String? message;
  final String? token;
  final UserData? user;

  AuthResponse({
    required this.status,
    this.message,
    this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final String userName;
  final String email;
  final String? phoneNumber;
  final List<String> roles;

  UserData({
    required this.userName,
    required this.email,
    this.phoneNumber,
    required this.roles,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      roles: (json['roles'] as List?)?.cast<String>() ?? [],
    );
  }
}