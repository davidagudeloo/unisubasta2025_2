import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TarjetaMisProductos extends StatelessWidget {
  final Size size;
  final String linkImagen;
  final String nombreProducto;
  final String descripcionProducto;
  final int precioActual;
  const TarjetaMisProductos({
    super.key,
    required this.size,
    required this.linkImagen,
    required this.nombreProducto,
    required this.descripcionProducto,
    required this.precioActual,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Esta funcionalidad estará disponible muy pronto...',
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(157, 158, 158, 158)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: size.width * 0.45,
              height: (size.width * 0.45) + 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    linkImagen,
                    fit: BoxFit.cover,
                    width: size.width * 0.45,
                    height: size.width * 0.45,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    height: 150,
                    // color: const Color.fromARGB(153, 230, 231, 233),
                    // color: const Color.fromARGB(255, 255, 255, 255),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombreProducto,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          descripcionProducto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Puja Actual: \n \$ ${NumberFormat.currency(locale: 'es_CO', symbol: 'cop', decimalDigits: 0).format(precioActual)}',
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text("Ver estado"),
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
