import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_producto.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';

class PujarScreen extends StatelessWidget {
  const PujarScreen({super.key});

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
              child: TituloSeccion(texto: '  Mis pujas'),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: [
                TarjetaProducto(
                  size: size,
                  linkImagen: [
                    'https://http2.mlstatic.com/D_NQ_NP_724892-MCO82040985608_022025-O.webp',
                  ],
                  nombreProducto: 'nintendo',
                  descripcionProducto: 'consola nintendo 3ds',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen: [
                    'https://images.offerup.com/43AES7Tk5-fRifdMB1YeFZd2HEE=/1440x1920/92a9/92a92065378d4759b0454b6be0d27d79.jpg',
                  ],
                  nombreProducto: 'Patines',
                  descripcionProducto: 'Se usaron solo una vez',
                  precioActual: 350000,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
