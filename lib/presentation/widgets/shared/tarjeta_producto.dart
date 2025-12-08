import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TarjetaProducto extends StatelessWidget {
  final Size size;
  final List<String> linkImagen;
  final String nombreProducto;
  final String descripcionProducto;
  final int precioActual;
  final int productId;
  final VoidCallback? onTap; // callback externo para manejar el tap

  const TarjetaProducto({
    super.key,
    required this.size,
    required this.linkImagen,
    required this.nombreProducto,
    required this.descripcionProducto,
    required this.precioActual,
    required this.productId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, // ya NO hace Navigator aquí, solo llama el callback
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(157, 158, 158, 158),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: size.width * 0.45,
              height: (size.width * 0.45) + 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    linkImagen.isNotEmpty
                        ? linkImagen.first
                        : 'https://cdn-icons-png.flaticon.com/512/679/679720.png',
                    fit: BoxFit.cover,
                    width: size.width * 0.45,
                    height: size.width * 0.45,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombreProducto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          descripcionProducto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Puja Actual: \n \$ ${NumberFormat.currency(
                            locale: 'es_CO',
                            symbol: 'cop',
                            decimalDigits: 0,
                          ).format(precioActual)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
