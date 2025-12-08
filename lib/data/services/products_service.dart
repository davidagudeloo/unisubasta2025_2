import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ProductsService {
  static const String baseUrl = 'http://192.168.30.114:8080';

  /// ============================
  /// OBTENER PRODUCTOS PAGINADOS
  /// ============================
  static Future<List<dynamic>> getProducts({
    int page = 0,
    int size = 20,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse(
      '$baseUrl/api/products?page=$page&size=$size',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'];
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  /// =====================================
  /// CREAR PRODUCTO CON DTO REAL DEL BACK
  /// =====================================
  static Future<int> createProduct({
    required String nombre,
    required String descripcion,
    required double precioMinimo,
    required DateTime openingDate,
    required DateTime closingDate,
    required int timerId,
    required int categoryId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final token = await user.getIdToken();

    final url = Uri.parse('$baseUrl/api/products');

    final body = {
      "id": 0,
      "name": nombre,
      "description": descripcion,
      "initialPrice": precioMinimo.toInt(),
      "openingDate": openingDate.toUtc().toIso8601String(),
      "closingDate": closingDate.toUtc().toIso8601String(),
      "timerId": timerId,
      "sellerId": 1,
      "buyerId": null,
      "productStateId": 1,
      "availabilityStateId": 1,
      "categoryId": categoryId,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Error al crear el producto: ${response.body}');
    }
  }

  /// ============================
  /// SUBIR IMAGEN AL PRODUCTO
  /// ============================
  static Future<void> uploadImage({
    required File image,
    required int productId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final token = await user.getIdToken();

    final url = Uri.parse('$baseUrl/api/products/images');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
        ),
      )
      ..fields['productId'] = productId.toString();

    final response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al subir imagen');
    }
  }

  /// ==================================
  /// OBTENER IMÁGENES POR PRODUCTO ID
  /// ==================================
  static Future<List<dynamic>> getImagesByProduct(int productId) async {
    final url = Uri.parse(
      '$baseUrl/api/products/images/by-product/$productId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener imágenes');
    }
  }

  /// ==================================
  /// OBTENER URL FÍSICA DE UNA IMAGEN
  /// ==================================
  static String getImageUrlById(int imageId) {
    return '$baseUrl/api/products/images/$imageId';
  }
}
