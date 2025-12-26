import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://85.15.176.78:5000/api';

  static Future<Map<String, dynamic>?> login(String name, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'password': password}),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }
}
