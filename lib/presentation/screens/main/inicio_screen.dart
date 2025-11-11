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
                      'https://scontent.feoh3-1.fna.fbcdn.net/v/t39.30808-6/579511332_4378206032501989_8379333194247747882_n.jpg?stp=cp6_dst-jpegr_s960x960_tt6&_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeGZypSkes_NjFvDeQxlQefDjWFgc1vpG1GNYWBzW-kbUSy2qvMLS5qR5OZKDY2ZR6F1iTjm2NTh7yUolStC_aZU&_nc_ohc=DQUb75padoMQ7kNvwE-f0SE&_nc_oc=AdnoZgYZxBxFJfFu8EaU2JKUbHJKL_6mZw24b5VAm3Rgjm9CgY_nBe-dI_KvFivFxq60XV8cDU7uXbluFXFRGPqp&_nc_zt=23&se=-1&_nc_ht=scontent.feoh3-1.fna&_nc_gid=YJSrW6rUdBxMBdRrojAoJA&oh=00_AfjFplxLxLNf5hjoU4QhovLz_52DVUl72ozQdIuH-AQyTg&oe=6916FF9C',
                  nombreProducto: 'Sanitario',
                  descripcionProducto: 'consola nintendo 3ds',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://scontent.fpei1-1.fna.fbcdn.net/v/t39.84726-6/580130641_863956686123092_5253275280330543909_n.jpg?stp=dst-jpg_p720x720_tt6&_nc_cat=101&ccb=1-7&_nc_sid=92e707&_nc_eui2=AeF2uZBRyROkdP6JT0io8g2cipskabOVkbuKmyRps5WRu-IVRarA9wdkhKgjt2EPgp3qPf0QITBhV5rYJfn3_Hx1&_nc_ohc=sifTI613TGQQ7kNvwFjX5Tm&_nc_oc=Adl1W1NHgMC2rtzUT_yOGM6E6uAuZP3bVNCahVHvyZmFCUM8pcOSl4-CE7Xxn2GHV2Gw2HgV8M-LKVhCeDU91aI0&_nc_zt=14&_nc_ht=scontent.fpei1-1.fna&_nc_gid=f-cdbu-PXlquJZ79A9433Q&oh=00_AfiS86ip63svYUKZwHo4BShbbK7kwdg7qAvPe3VidWZafQ&oe=691705BA',
                  nombreProducto: 'Patines',
                  descripcionProducto: 'monitor asus como nuevo',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://scontent.fctg2-1.fna.fbcdn.net/v/t39.30808-6/578112607_10164884996186554_1395215200190818348_n.jpg?stp=dst-jpg_s960x960_tt6&_nc_cat=107&ccb=1-7&_nc_sid=454cf4&_nc_eui2=AeFtrxD7Vv_x0nNqqf12wfV5A0YDI1iOLrMDRgMjWI4usxabWpD-vW0URgqf_xJo-PHjbJ2Gzw__NsnEJe4nY__0&_nc_ohc=08n4smcxSq8Q7kNvwHjFjUb&_nc_oc=Adl59PZYKz0S4wjBicXTh_guWLJ4_ZcE7ShQ2PGQbG59iO24HeOAlkkuKu8sGCOhBoE1HPYqODU9kkBTWTZmY7wk&_nc_zt=23&_nc_ht=scontent.fctg2-1.fna&_nc_gid=s_PvJnq1yYMkxFBPRCRsyQ&oh=00_AfjbmPO8jgiRxbNCSRURE3Au_896mcaU2ow_1I5X-j-F6A&oe=69170CCA',
                  nombreProducto: 'Carro',
                  descripcionProducto: 'cama muy poco usada',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://scontent.fctg2-1.fna.fbcdn.net/v/t39.84726-6/561526608_25237715672512503_1023215375763300002_n.jpg?stp=dst-jpg_s960x960_tt6&_nc_cat=106&ccb=1-7&_nc_sid=92e707&_nc_eui2=AeFYlrx0Od_TofOqLlLmL8CfNMUbFY245ww0xRsVjbjnDOT3_pOD8ivOaEi3ti1P7CVLAglLfb-6taOy4UPKZJbq&_nc_ohc=K8KykGMVGNsQ7kNvwEgeilX&_nc_oc=Adk8y7wLmOC70JVCPGL0y5lucVRhVv33vGCjsj12cxcvutXWh1QogzG3sh2zSGzqu72uISFP2fHRX8o8dT8O2EI-&_nc_zt=14&_nc_ht=scontent.fctg2-1.fna&_nc_gid=SX5ZOCYcCOD718rfAc4CgA&oh=00_Afh-tzEuG1nvIW7a2t2Vn2boo09OYIWcWS6FJtYSypfoWA&oe=691701DE',
                  nombreProducto: 'Samsung s6 lite',
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
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://scontent.feoh3-1.fna.fbcdn.net/v/t39.30808-6/579511332_4378206032501989_8379333194247747882_n.jpg?stp=cp6_dst-jpegr_s960x960_tt6&_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeGZypSkes_NjFvDeQxlQefDjWFgc1vpG1GNYWBzW-kbUSy2qvMLS5qR5OZKDY2ZR6F1iTjm2NTh7yUolStC_aZU&_nc_ohc=DQUb75padoMQ7kNvwE-f0SE&_nc_oc=AdnoZgYZxBxFJfFu8EaU2JKUbHJKL_6mZw24b5VAm3Rgjm9CgY_nBe-dI_KvFivFxq60XV8cDU7uXbluFXFRGPqp&_nc_zt=23&se=-1&_nc_ht=scontent.feoh3-1.fna&_nc_gid=YJSrW6rUdBxMBdRrojAoJA&oh=00_AfjFplxLxLNf5hjoU4QhovLz_52DVUl72ozQdIuH-AQyTg&oe=6916FF9C',
                  nombreProducto: 'nintendo',
                  descripcionProducto: 'consola nintendo 3ds',
                  precioActual: 300000,
                ),
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
                      'https://scontent.fctg2-1.fna.fbcdn.net/v/t39.30808-6/578112607_10164884996186554_1395215200190818348_n.jpg?stp=dst-jpg_s960x960_tt6&_nc_cat=107&ccb=1-7&_nc_sid=454cf4&_nc_eui2=AeFtrxD7Vv_x0nNqqf12wfV5A0YDI1iOLrMDRgMjWI4usxabWpD-vW0URgqf_xJo-PHjbJ2Gzw__NsnEJe4nY__0&_nc_ohc=08n4smcxSq8Q7kNvwHjFjUb&_nc_oc=Adl59PZYKz0S4wjBicXTh_guWLJ4_ZcE7ShQ2PGQbG59iO24HeOAlkkuKu8sGCOhBoE1HPYqODU9kkBTWTZmY7wk&_nc_zt=23&_nc_ht=scontent.fctg2-1.fna&_nc_gid=s_PvJnq1yYMkxFBPRCRsyQ&oh=00_AfjbmPO8jgiRxbNCSRURE3Au_896mcaU2ow_1I5X-j-F6A&oe=69170CCA',
                  nombreProducto: 'cama',
                  descripcionProducto: 'cama muy poco usada',
                  precioActual: 300000,
                ),
                TarjetaProducto(
                  size: size,
                  linkImagen:
                      'https://scontent.fctg2-1.fna.fbcdn.net/v/t39.84726-6/561526608_25237715672512503_1023215375763300002_n.jpg?stp=dst-jpg_s960x960_tt6&_nc_cat=106&ccb=1-7&_nc_sid=92e707&_nc_eui2=AeFYlrx0Od_TofOqLlLmL8CfNMUbFY245ww0xRsVjbjnDOT3_pOD8ivOaEi3ti1P7CVLAglLfb-6taOy4UPKZJbq&_nc_ohc=K8KykGMVGNsQ7kNvwEgeilX&_nc_oc=Adk8y7wLmOC70JVCPGL0y5lucVRhVv33vGCjsj12cxcvutXWh1QogzG3sh2zSGzqu72uISFP2fHRX8o8dT8O2EI-&_nc_zt=14&_nc_ht=scontent.fctg2-1.fna&_nc_gid=SX5ZOCYcCOD718rfAc4CgA&oh=00_Afh-tzEuG1nvIW7a2t2Vn2boo09OYIWcWS6FJtYSypfoWA&oe=691701DE',
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
