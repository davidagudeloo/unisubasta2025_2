import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_mis_productos.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_producto.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: [
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://www.surtibaby.com/cdn/shop/products/BACINILLAPLEGABLEINOLAGLORIA-2.jpg?v=1659707593',
                  nombreProducto: 'Sanitario',
                  descripcionProducto: 'para el bebé que más quieres',
                  precioActual: 50000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://images.offerup.com/43AES7Tk5-fRifdMB1YeFZd2HEE=/1440x1920/92a9/92a92065378d4759b0454b6be0d27d79.jpg',
                  nombreProducto: 'Patines',
                  descripcionProducto: 'Se usaron solo una vez',
                  precioActual: 350000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://acroadtrip.blob.core.windows.net/publicaciones-imagenes/Small/chevrolet/spark/co/RT_PU_01e4e63812b647559816023531be2c90.webp',
                  nombreProducto: 'Carro',
                  descripcionProducto: 'El terror de las nenas',
                  precioActual: 12000000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://http2.mlstatic.com/D_NQ_NP_998696-MCO88023764366_072025-O.webp',
                  nombreProducto: 'Samsung s6 lite',
                  descripcionProducto: 'no se ha abierto nunca',
                  precioActual: 700000,
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
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://www.surtibaby.com/cdn/shop/products/BACINILLAPLEGABLEINOLAGLORIA-2.jpg?v=1659707593',
                  nombreProducto: 'sanitario',
                  descripcionProducto: 'para bebés',
                  precioActual: 50000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://images.offerup.com/43AES7Tk5-fRifdMB1YeFZd2HEE=/1440x1920/92a9/92a92065378d4759b0454b6be0d27d79.jpg',
                  nombreProducto: 'patines',
                  descripcionProducto: 'monitor asus como nuevo',
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
