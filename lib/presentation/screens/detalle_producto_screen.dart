import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:unisubasta_udea_v1/data/services/bid_service.dart';
import 'package:unisubasta_udea_v1/data/models/bid_model.dart';

class DetalleProductoScreen extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final int precio;
  final int productId;
  final List<String> imagenes;

  const DetalleProductoScreen({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.productId,
    required this.imagenes,
  });

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  late final PageController _controller;
  int _paginaActual = 0;

  final TextEditingController _pujaController = TextEditingController();

  int _precioActual = 0;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _precioActual = widget.precio;
  }

  @override
  void dispose() {
    _controller.dispose();
    _pujaController.dispose();
    super.dispose();
  }

  void _mostrarImagenPantallaCompleta(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              child: Center(child: Image.network(imageUrl)),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _hacerPuja() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes iniciar sesión para pujar.")),
      );
      return;
    }

    if (_pujaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa una cantidad válida")),
      );
      return;
    }

    final int? cantidad = int.tryParse(_pujaController.text.trim());

    if (cantidad == null || cantidad <= _precioActual) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La puja debe ser mayor a $_precioActual")),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final BidModel bid = await BidService.createBid(
        user: user,
        productId: widget.productId,
        amount: cantidad,
      );

      setState(() {
        _precioActual = bid.proposedPrice;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Puja realizada con éxito")),
      );

      _pujaController.clear();

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombre,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _controller,
                      itemCount: widget.imagenes.length,
                      onPageChanged: (index) {
                        setState(() => _paginaActual = index);
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = widget.imagenes[index];

                        return GestureDetector(
                          onTap: () =>
                              _mostrarImagenPantallaCompleta(imageUrl),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imagenes.length,
                          (index) => Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            width: _paginaActual == index ? 10 : 8,
                            height: _paginaActual == index ? 10 : 8,
                            decoration: BoxDecoration(
                              color: _paginaActual == index
                                  ? Colors.white
                                  : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.descripcion,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Precio actual: \$${NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0).format(_precioActual)}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _pujaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tu puja',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _cargando ? null : _hacerPuja,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Pujar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
