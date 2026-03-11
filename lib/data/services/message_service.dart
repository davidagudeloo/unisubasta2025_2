import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisubasta_udea_v1/data/models/message_model.dart';

class MessageService {
  static const String baseUrl = "https://codefact.udea.edu.co/unisubastas";

  static Future<String> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");
    return (await user.getIdToken())!;
  }

  static Future<List<MessageModel>> getMessages(int chatId) async {
    final token = await _getToken();
    final url = Uri.parse("$baseUrl/api/messages/$chatId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body as List).map((e) => MessageModel.fromJson(e)).toList();
    }

    throw Exception("Error al obtener mensajes");
  }

  static Future<void> sendMessage({
    required int chatId,
    required int emitterId,
    required String text,
  }) async {
    final token = await _getToken();

    final url = Uri.parse("$baseUrl/api/messages/text");

    final body = jsonEncode({
      "id": 0,
      "message": text,
      "chatId": chatId,
      "emitterId": emitterId,
      "dateTime": DateTime.now().toUtc().toIso8601String(),
    });

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("No se pudo enviar el mensaje");
    }
  }
}
