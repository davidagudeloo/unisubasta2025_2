import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleProductoScreen extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final int precio;
  final String imagen;

  const DetalleProductoScreen({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // Carrusel de imágenes (puedes tener varias)
              SizedBox(
                height: 300,
                child: PageView(
                  controller: controller,
                  children: [
                    Image.network(imagen, fit: BoxFit.cover),
                    // Image.network(imagen, fit: BoxFit.cover),
                    // aquí podrías añadir más imágenes si las tienes
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(descripcion, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              Text(
                'Precio actual: \$${NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0).format(precio)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Campo para ingresar puja
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tu puja',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Has realizado una puja!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Pujar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
