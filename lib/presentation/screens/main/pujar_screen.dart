import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisubasta_udea_v1/data/services/bid_service.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/models/bid_model.dart';
import 'package:unisubasta_udea_v1/data/models/product_model.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_producto.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';
import 'package:unisubasta_udea_v1/presentation/screens/detalle_producto_screen.dart';

class PujarScreen extends StatefulWidget {
  const PujarScreen({super.key});

  @override
  State<PujarScreen> createState() => _PujarScreenState();
}

class _PujarScreenState extends State<PujarScreen> {
  late Future<List<_PujaConProducto>> _futurePujas;

  @override
  void initState() {
    super.initState();
    _futurePujas = cargarMisPujas();
  }

  Future<List<_PujaConProducto>> cargarMisPujas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");

    // 1. Obtener todas mis pujas
    List<BidModel> bids = await BidService.getMyBids(user);

    // ================================================================
    // 2. ELIMINAR DUPLICADOS (quedarse solo con la ÚLTIMA puja por producto)
    // ================================================================
    final Map<int, BidModel> lastBidByProduct = {};

    for (final bid in bids) {
      lastBidByProduct[bid.productId] = bid;
    }

    // Convertimos el mapa en lista final
    final List<BidModel> filteredBids = lastBidByProduct.values.toList();

    // 3. Para cada puja obtenemos el producto e imágenes
    List<_PujaConProducto> result = [];

    for (final b in filteredBids) {
      final ProductModel product =
          await BidService.getProductById(user: user, productId: b.productId);

      final List<dynamic> imgs =
          await ProductsService.getImagesByProduct(product.id);

      final List<String> urls = imgs.isEmpty
          ? ["https://cdn-icons-png.flaticon.com/512/679/679720.png"]
          : imgs
              .map<String>((img) => ProductsService.getImageUrlById(img["id"]))
              .toList();

      result.add(
        _PujaConProducto(
          bid: b,
          product: product,
          imagenes: urls,
        ),
      );
    }

    return result;
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
              child: TituloSeccion(texto: "  Mis pujas"),
            ),

            FutureBuilder<List<_PujaConProducto>>(
              future: _futurePujas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                final pujas = snapshot.data ?? [];

                if (pujas.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text("No has realizado ninguna puja"),
                  );
                }

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  children: pujas.map((puja) {
                    final product = puja.product;

                    return TarjetaProducto(
                      size: size,
                      linkImagen: puja.imagenes,
                      nombreProducto: product.name,
                      descripcionProducto: product.description,
                      precioActual: product.currentPrice.toInt(),
                      productId: product.id,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalleProductoScreen(
                              nombre: product.name,
                              descripcion: product.description,
                              precio: product.currentPrice.toInt(),
                              productId: product.id,
                              imagenes: puja.imagenes,
                            ),
                          ),
                        );

                        setState(() {
                          _futurePujas = cargarMisPujas();
                        });
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

class _PujaConProducto {
  final BidModel bid;
  final ProductModel product;
  final List<String> imagenes;

  _PujaConProducto({
    required this.bid,
    required this.product,
    required this.imagenes,
  });
}
