import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:unisubasta_udea_v1/data/models/product_model.dart';

class ProductsService {
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
      return data["idUsuario"]; // ← este es el ID real de PostgreSQL
    }

    return null;
  }

  // ============================================================
  // Obtener todos los productos (Paginados)
  // ============================================================
  static Future<List<ProductModel>> getProducts({
    int page = 0,
    int size = 20,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse('$baseUrl/api/products?page=$page&size=$size');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> content = data['content'];
      return content.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  // ============================================================
  // Obtener productos por vendedor
  // ============================================================
  static Future<List<ProductModel>> getProductsBySeller(int sellerId) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse('$baseUrl/api/products/by-seller/$sellerId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos del vendedor');
    }
  }

  // ============================================================
  // Crear producto (ASIGNANDO EL SELLER ID REAL)
  // ============================================================
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
    if (user == null) throw Exception('Usuario no autenticado');

    final token = await user.getIdToken();

    // Obtener el ID real del backend
    final myUserId = await getMyUserId();
    if (myUserId == null) throw Exception("No fue posible obtener el ID del usuario.");

    final url = Uri.parse('$baseUrl/api/products');

    final body = {
      "id": 0,
      "name": nombre,
      "description": descripcion,
      "initialPrice": precioMinimo.toInt(),
      "currentPrice": precioMinimo.toInt(),
      "openingDate": openingDate.toUtc().toIso8601String(),
      "closingDate": closingDate.toUtc().toIso8601String(),
      "timerId": timerId,
      "sellerId": myUserId, // ← AQUÍ EL CAMBIO IMPORTANTE
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

  // ============================================================
  // Actualizar producto
  // ============================================================
  static Future<void> updateProduct({
    required int productId,
    required double nuevoPrecio,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse('$baseUrl/api/products/$productId');

    final body = {
      "initialPrice": nuevoPrecio.toInt(),
      "currentPrice": nuevoPrecio.toInt(),
    };

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }

  // ============================================================
  // Subir imagen
  // ============================================================
  static Future<void> uploadImage({
    required File image,
    required int productId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final token = await user.getIdToken();
    final url = Uri.parse('$baseUrl/api/products/images');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', image.path))
      ..fields['productId'] = productId.toString();

    final response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al subir imagen');
    }
  }

  // ============================================================
  // Obtener imágenes por producto
  // ============================================================
  static Future<List<dynamic>> getImagesByProduct(int productId) async {
    final url = Uri.parse('$baseUrl/api/products/images/by-product/$productId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener imágenes');
    }
  }

  // ============================================================
  // Obtener URL de imagen
  // ============================================================
  static String getImageUrlById(int imageId) {
    return '$baseUrl/api/products/images/$imageId';
  }

  // ============================================================
  // Eliminar imagen
  // ============================================================
  static Future<void> deleteImageById(int imageId) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse('$baseUrl/api/products/images/$imageId');

    final response = await http.delete(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar imagen');
    }
  }

  // ============================================================
  // Eliminar producto
  // ============================================================
  static Future<void> deleteProductById(int productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    final url = Uri.parse('$baseUrl/api/products/$productId');

    final response = await http.delete(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
  }

  // ============================================================
  // Eliminar producto + imágenes
  // ============================================================
  static Future<void> deleteProductWithImages(int productId) async {
    final images = await getImagesByProduct(productId);

    for (final img in images) {
      final int imageId = img['id'];
      await deleteImageById(imageId);
    }

    await deleteProductById(productId);
  }
}
