import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:unisubasta_udea_v1/data/models/bid_model.dart';
import 'package:unisubasta_udea_v1/data/models/product_model.dart';

class BidService {
  static const String baseUrl = 'http://192.168.30.114:8080';

  // Crear una nueva puja
  static Future<BidModel> createBid({
    required User user,
    required int productId,
    required int amount,
  }) async {
    final token = await user.getIdToken();
    final url = Uri.parse('$baseUrl/api/bids');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "productId": productId,
        "proposedPrice": amount,
      }),
    );

    if (response.statusCode == 200) {
      return BidModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("La puja no es válida");
    } else if (response.statusCode == 404) {
      throw Exception("Producto o usuario no encontrado");
    } else if (response.statusCode == 401) {
      throw Exception("No autenticado");
    } else {
      throw Exception("Error inesperado: ${response.statusCode}");
    }
  }

  // Obtener todas las pujas de un producto específico
  static Future<List<BidModel>> getBidsByProduct({
    required User user,
    required int productId,
  }) async {
    final token = await user.getIdToken();
    final url = Uri.parse('$baseUrl/api/bids/product/$productId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => BidModel.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      throw Exception("Producto no encontrado");
    } else if (response.statusCode == 401) {
      throw Exception("No autenticado");
    } else {
      throw Exception("Error inesperado: ${response.statusCode}");
    }
  }

  // Obtener las pujas del usuario autenticado
  static Future<List<BidModel>> getMyBids(User user) async {
    final token = await user.getIdToken();
    final url = Uri.parse('$baseUrl/api/bids/user/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => BidModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("No autenticado");
    } else if (response.statusCode == 404) {
      throw Exception("Usuario no encontrado");
    } else {
      throw Exception("Error inesperado: ${response.statusCode}");
    }
  }

  // Obtener los datos completos de un producto por ID (se necesita en Mis Pujas)
  static Future<ProductModel> getProductById({
    required User user,
    required int productId,
  }) async {
    final token = await user.getIdToken();
    final url = Uri.parse('$baseUrl/api/products/$productId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("Producto no encontrado");
    } else if (response.statusCode == 401) {
      throw Exception("No autenticado");
    } else {
      throw Exception("Error inesperado: ${response.statusCode}");
    }
  }
}
