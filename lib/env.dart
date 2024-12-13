import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}