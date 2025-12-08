import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://192.168.30.114:8080';

  static Future<Map<String, dynamic>> getUserProfile(User user) async {
    final token = await user.getIdToken();

    final url = Uri.parse('$baseUrl/api/users/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener perfil: ${response.statusCode}');
    }
  }

  static Future<bool> updateDescripcion(User user, String descripcion) async {
    final token = await user.getIdToken();

    final url = Uri.parse('$baseUrl/api/users/me');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "descripcionPersonal": descripcion,
      }),
    );

    return response.statusCode == 200;
  }
}
