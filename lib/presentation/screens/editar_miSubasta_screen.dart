import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/services/bid_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarEliminarSubastaScreen extends StatefulWidget {
  final int productId;
  final String nombre;
  final String descripcion;
  final int precio;
  final List<String> imagenes;

  const EditarEliminarSubastaScreen({
    super.key,
    required this.productId,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenes,
  });

  @override
  State<EditarEliminarSubastaScreen> createState() =>
      _EditarEliminarSubastaScreenState();
}

class _EditarEliminarSubastaScreenState
    extends State<EditarEliminarSubastaScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _precioController = TextEditingController();

  late PageController _controller;
  int _paginaActual = 0;

  final List<File?> _nuevasImagenes = [null, null, null];

  bool _guardando = false;
  bool _tienePujas = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _precioController.text = widget.precio.toString();
    verificarPujas();
  }

  Future<void> verificarPujas() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final bids =
          await BidService.getBidsByProduct(user: user, productId: widget.productId);

      if (bids.isNotEmpty) {
        setState(() => _tienePujas = true);
      }
    } catch (_) {
      setState(() => _tienePujas = false);
    }
  }

  Future<void> _seleccionarImagen(int index) async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => _nuevasImagenes[index] = File(imagen.path));
    }
  }

  Future<void> _guardarCambios() async {
    if (!_tienePujas && _precioController.text.isEmpty) return;

    setState(() => _guardando = true);

    try {
      if (!_tienePujas) {
        await ProductsService.updateProduct(
          productId: widget.productId,
          nuevoPrecio: double.parse(_precioController.text),
        );
      }

      for (final img in _nuevasImagenes) {
        if (img != null) {
          await ProductsService.uploadImage(
            image: img,
            productId: widget.productId,
          );
        }
      }

      if (!mounted) return;
      setState(() => _guardando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subasta actualizada correctamente')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _guardando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  Future<void> _eliminarProducto() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar subasta'),
        content: const Text('¿Seguro que deseas eliminar esta subasta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ProductsService.deleteProductWithImages(widget.productId);
      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

  void _mostrarImagenFullscreen(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              child: Center(
                child: Image.network(imageUrl),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombre)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _controller,
                      itemCount: widget.imagenes.length,
                      onPageChanged: (i) => setState(() => _paginaActual = i),
                      itemBuilder: (context, index) {
                        final imageUrl = widget.imagenes[index];
                        return GestureDetector(
                          onTap: () => _mostrarImagenFullscreen(imageUrl),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
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
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _paginaActual == i ? 10 : 8,
                            height: _paginaActual == i ? 10 : 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.descripcion),
              ),

              const SizedBox(height: 20),

              if (!_tienePujas)
                TextField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nuevo precio',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                )
              else
                const SizedBox(),

              const SizedBox(height: 20),

              const Text('Agregar nuevas imágenes'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(3, (i) {
                  return InkWell(
                    onTap: () => _seleccionarImagen(i),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.verdeClaro,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _nuevasImagenes[i] == null
                          ? const Icon(Icons.add_photo_alternate)
                          : Image.file(
                              _nuevasImagenes[i]!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _eliminarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text(
                    'Eliminar subasta',
                    style: TextStyle(color: Colors.white),
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
