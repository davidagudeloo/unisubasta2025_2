import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class TimersService {
  static const String baseUrl = 'https://codefact.udea.edu.co/unisubastas';

  static Future<int> createTimer(int milliseconds) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final token = await user.getIdToken();

    final url = Uri.parse('$baseUrl/api/products/timers');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "id": 0,
        "timer": milliseconds,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // ✅ ESTE ID SE USA PARA CREAR EL PRODUCTO
    } else {
      throw Exception('Error al crear temporizador: ${response.body}');
    }
  }
}
