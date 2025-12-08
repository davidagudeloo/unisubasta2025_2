import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_producto.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/models/product_model.dart';

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
    final data = await ProductsService.getProducts();
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  // SOLO USA EL SERVICE (NADA DE HTTP ACÁ)
  Future<String?> cargarPrimeraImagen(int productId) async {
    try {
      final images = await ProductsService.getImagesByProduct(productId);

      if (images.isNotEmpty) {
        final imageId = images.first['id'];
        return ProductsService.getImageUrlById(imageId);
      }
    } catch (_) {}

    return null;
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

                final products = snapshot.data!;

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
                    return FutureBuilder<String?>(
                      future: cargarPrimeraImagen(product.id),
                      builder: (context, imageSnapshot) {
                        final imageUrl = imageSnapshot.data ??
                            'https://cdn-icons-png.flaticon.com/512/679/679720.png';

                        return TarjetaProducto(
                          size: size,
                          linkImagen: imageUrl,
                          nombreProducto: product.name,
                          descripcionProducto: product.description,
                          precioActual: product.initialPrice.toInt(),
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
