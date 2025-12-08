import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_producto.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/models/product_model.dart';
import 'package:unisubasta_udea_v1/presentation/screens/detalle_producto_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/editar_miSubasta_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = cargarProductos();
  }

  Future<List<ProductModel>> cargarProductos() async {
    return await ProductsService.getProducts();
  }

  Future<List<String>> cargarImagenesProducto(int productId) async {
    try {
      final images = await ProductsService.getImagesByProduct(productId);

      if (images.isNotEmpty) {
        return images
            .map<String>((img) => ProductsService.getImageUrlById(img['id']))
            .toList();
      }
    } catch (_) {}

    return ['https://cdn-icons-png.flaticon.com/512/679/679720.png'];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: TituloSeccion(texto: '  Productos disponibles'),
            ),

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
                    child: Text('Error al cargar productos'),
                  );
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text('No hay productos disponibles'),
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
                        final imagenes = imageSnapshot.data ??
                            ['https://cdn-icons-png.flaticon.com/512/679/679720.png'];

                        return TarjetaProducto(
                          size: size,
                          linkImagen: imagenes,
                          nombreProducto: product.name,
                          descripcionProducto: product.description,
                          precioActual: product.initialPrice.toInt(),
                          productId: product.id,

                          // LÓGICA CORRECTA AQUÍ
                          onTap: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) return;

                            // Obtener ID real de PostgreSQL
                            final myUserId = await ProductsService.getMyUserId();

                            if (myUserId != null &&
                                product.sellerId == myUserId) {
                              //  ES MI PRODUCTO → EDITAR
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditarEliminarSubastaScreen(
                                    productId: product.id,
                                    nombre: product.name,
                                    descripcion: product.description,
                                    precio: product.initialPrice.toInt(),
                                    imagenes: imagenes,
                                  ),
                                ),
                              );

                              // Recargar
                              setState(() {
                                _productsFuture = cargarProductos();
                              });
                            } else {
                              // ✔ NO ES MÍO → PUJAR
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleProductoScreen(
                                    nombre: product.name,
                                    descripcion: product.description,
                                    precio: product.initialPrice.toInt(),
                                    productId: product.id,
                                    imagenes: imagenes,
                                  ),
                                ),
                              );
                            }
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
    );
  }
}
