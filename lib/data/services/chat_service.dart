import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:unisubasta_udea_v1/data/models/chat_model.dart';

class ChatService {
  static const String baseUrl = 'http://192.168.30.114:8080';

  // ============================================================
  // Obtener ID REAL del usuario logueado desde backend
  // ============================================================
  static Future<int?> getMyUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse('$baseUrl/api/users/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["idUsuario"];
    }

    return null;
  }

  // ============================================================
  // Obtener todos los chats donde participa el usuario
  // ============================================================
  static Future<List<ChatModel>> getMyChats() async {
    final userId = await getMyUserId();
    if (userId == null) throw Exception("No se pudo obtener el id del usuario");

    final url = Uri.parse('$baseUrl/api/chats/user/$userId');

    final authUser = FirebaseAuth.instance.currentUser;
    final token = await authUser?.getIdToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> raw = jsonDecode(response.body);
      return raw.map((e) => ChatModel.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar chats");
    }
  }
}
