import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_mis_productos.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';

import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/services/user_service.dart';

import 'package:unisubasta_udea_v1/data/models/product_model.dart';
import 'package:unisubasta_udea_v1/presentation/screens/editar_miSubasta_screen.dart';

class MisSubastasScreen extends StatefulWidget {
  const MisSubastasScreen({super.key});

  @override
  State<MisSubastasScreen> createState() => _MisSubastasScreenState();
}

class _MisSubastasScreenState extends State<MisSubastasScreen> {
  late Future<List<ProductModel>> _productsFuture;

  int? sellerId; // AHORA NO ESTÁ QUEMADO

  @override
  void initState() {
    super.initState();
    _cargarUsuarioYProductos();
  }

  // ============================================================
  //   Obtener ID del usuario autenticado (desde backend)
  // ============================================================
  Future<void> _cargarUsuarioYProductos() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final perfil = await UserService.getUserProfile(user);

      sellerId = perfil["idUsuario"]; // 🔥 ID REAL DEL USUARIO

      setState(() {
        _productsFuture = cargarMisProductos();
      });

    } catch (e) {
      debugPrint("Error obteniendo ID del usuario: $e");
    }
  }

  // ============================================================
  //    Cargar productos del vendedor REAL
  // ============================================================
  Future<List<ProductModel>> cargarMisProductos() async {
    if (sellerId == null) return [];

    return await ProductsService.getProductsBySeller(sellerId!);
  }

  Future<List<String>> cargarImagenesProducto(int productId) async {
    final images = await ProductsService.getImagesByProduct(productId);

    return images
        .map<String>((img) => ProductsService.getImageUrlById(img['id']))
        .toList();
  }

  void _recargarPantalla() {
    setState(() {
      _productsFuture = cargarMisProductos();
    });
  }

  // ============================================================
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => _recargarPantalla(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: TituloSeccion(texto: '  Mis subastas'),
              ),

              if (sellerId == null)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: CircularProgressIndicator(),
                )
              else
                FutureBuilder<List<ProductModel>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text('Error al cargar tus subastas'),
                      );
                    }

                    final products = snapshot.data ?? [];

                    if (products.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text('Aún no has publicado productos'),
                      );
                    }

                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.spaceBetween,
                      children: products.map((product) {
                        return FutureBuilder<List<String>>(
                          future: cargarImagenesProducto(product.id),
                          builder: (context, imageSnapshot) {
                            final imagenes = imageSnapshot.data ?? [];

                            final imageUrl = imagenes.isNotEmpty
                                ? imagenes.first
                                : 'https://cdn-icons-png.flaticon.com/512/679/679720.png';

                            return TarjetaMisProductos(
                              size: size,
                              linkImagen: imageUrl,
                              nombreProducto: product.name,
                              descripcionProducto: product.description,
                              precioActual: product.initialPrice.toInt(),

                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditarEliminarSubastaScreen(
                                      productId: product.id,
                                      nombre: product.name,
                                      descripcion: product.description,
                                      precio: product.initialPrice.toInt(),
                                      imagenes: imagenes.isNotEmpty
                                          ? imagenes
                                          : [imageUrl],
                                    ),
                                  ),
                                );

                                _recargarPantalla();
                              },
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
