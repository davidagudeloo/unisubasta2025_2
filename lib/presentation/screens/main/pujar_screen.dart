import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/tarjeta_mis_productos.dart';
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
                  linkImagen:
                      'https://scontent.fpei1-1.fna.fbcdn.net/v/t39.84726-6/580130641_863956686123092_5253275280330543909_n.jpg?stp=dst-jpg_p720x720_tt6&_nc_cat=101&ccb=1-7&_nc_sid=92e707&_nc_eui2=AeF2uZBRyROkdP6JT0io8g2cipskabOVkbuKmyRps5WRu-IVRarA9wdkhKgjt2EPgp3qPf0QITBhV5rYJfn3_Hx1&_nc_ohc=sifTI613TGQQ7kNvwFjX5Tm&_nc_oc=Adl1W1NHgMC2rtzUT_yOGM6E6uAuZP3bVNCahVHvyZmFCUM8pcOSl4-CE7Xxn2GHV2Gw2HgV8M-LKVhCeDU91aI0&_nc_zt=14&_nc_ht=scontent.fpei1-1.fna&_nc_gid=f-cdbu-PXlquJZ79A9433Q&oh=00_AfiS86ip63svYUKZwHo4BShbbK7kwdg7qAvPe3VidWZafQ&oe=691705BA',
                  nombreProducto: 'monitor',
                  descripcionProducto: 'monitor asus como nuevo',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
