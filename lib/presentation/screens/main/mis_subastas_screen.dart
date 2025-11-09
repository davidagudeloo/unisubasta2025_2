import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_producto.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';

class MisSubastasScreen extends StatelessWidget {
  const MisSubastasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: TituloSeccion(texto: 'Mis subastas'),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: [
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_724892-MCO82040985608_022025-O.webp',
                  nombreProducto: 'nintendo',
                  descripcionProducto: 'consola nintendo 3ds',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_2X_779137-MCO92673866773_092025-T.webp',
                  nombreProducto: 'monitor',
                  descripcionProducto: 'monitor asus como nuevo',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_787116-MLA86670756325_062025-O.webp',
                  nombreProducto: 'cama',
                  descripcionProducto: 'cama muy poco usada',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_614622-MCO89682925106_082025-O.webp',
                  nombreProducto: 'algebra de baldor',
                  descripcionProducto: 'no se ha abierto nunca',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_724892-MCO82040985608_022025-O.webp',
                  nombreProducto: 'nintendo',
                  descripcionProducto: 'consola nintendo 3ds',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_2X_779137-MCO92673866773_092025-T.webp',
                  nombreProducto: 'monitor',
                  descripcionProducto: 'monitor asus como nuevo',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_787116-MLA86670756325_062025-O.webp',
                  nombreProducto: 'cama',
                  descripcionProducto: 'cama muy poco usada',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_614622-MCO89682925106_082025-O.webp',
                  nombreProducto: 'algebra de baldor',
                  descripcionProducto: 'no se ha abierto nunca',
                  precioActual: 300000,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
