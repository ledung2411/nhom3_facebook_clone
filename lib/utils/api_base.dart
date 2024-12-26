
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api/auth_api.dart';

class ApiBase {
final AuthApi _authApi = AuthApi();

Future<http.Response> get(String url) async {
final headers = await _authApi.getHeaders();
return await http.get(Uri.parse(url), headers: headers);
}

Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
final headers = await _authApi.getHeaders();
return await http.post(
Uri.parse(url),
headers: headers,
body: body != null ? jsonEncode(body) : null,
);
}

Future<http.Response> put(String url, {Map<String, dynamic>? body}) async {
final headers = await _authApi.getHeaders();
return await http.put(
Uri.parse(url),
headers: headers,
body: body != null ? jsonEncode(body) : null,
);
}

Future<http.Response> delete(String url) async {
final headers = await _authApi.getHeaders();
return await http.delete(Uri.parse(url), headers: headers);
}
}