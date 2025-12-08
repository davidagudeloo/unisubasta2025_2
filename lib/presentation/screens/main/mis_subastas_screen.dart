import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_mis_productos.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/models/product_model.dart';
import 'package:unisubasta_udea_v1/presentation/screens/editar_miSubasta_screen.dart';

class MisSubastasScreen extends StatefulWidget {
  const MisSubastasScreen({super.key});

  @override
  State<MisSubastasScreen> createState() => _MisSubastasScreenState();
}

class _MisSubastasScreenState extends State<MisSubastasScreen> {
  late Future<List<ProductModel>> _productsFuture;
  final int sellerId = 1;

  @override
  void initState() {
    super.initState();
    _productsFuture = cargarMisProductos();
  }

  Future<List<ProductModel>> cargarMisProductos() async {
    final data = await ProductsService.getProductsBySeller(sellerId);
    return data.map((e) => ProductModel.fromJson(e)).toList();
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

                  final products = snapshot.data!;

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

                            /// AQUÍ ESTÁ LA CLAVE
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

                              // RECARGA AUTOMÁTICA AL VOLVER
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
