import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'https://codefact.udea.edu.co/unisubastas';

  // ==========================================
  // Obtener perfil del usuario autenticado
  // ==========================================
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

  // ==========================================
  // Actualizar descripción personal
  // ==========================================
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

  // ==========================================
  // NUEVO: obtener usuario por ID SQL
  // ==========================================
  static Future<Map<String, dynamic>> getUserById(int id) async {
    final authUser = FirebaseAuth.instance.currentUser;
    final token = await authUser?.getIdToken();

    final url = Uri.parse('$baseUrl/api/users/$id');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener usuario por id: ${response.body}");
    }
  }
}
