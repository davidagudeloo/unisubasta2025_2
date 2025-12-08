import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_app_bar.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_seccion.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/services/timers_service.dart';

class RegistroProductoScreen extends StatefulWidget {
  const RegistroProductoScreen({super.key});

  @override
  State<RegistroProductoScreen> createState() => _RegistroProductoScreenState();
}

class _RegistroProductoScreenState extends State<RegistroProductoScreen> {
  bool _librosSeleccionado = false;
  bool _ropaSeleccionado = false;
  bool _mueblesSeleccionado = false;
  bool _computadoresSeleccionado = false;
  bool _celularesSeleccionado = false;
  bool _vehiculosSeleccionado = false;
  bool _otrosSeleccionado = false;

  int _tiempoSeleccionado = 24;
  bool _publicando = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File?> _imagenes = [null, null, null];

  Future<void> _seleccionarImagen(int index) async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => _imagenes[index] = File(imagen.path));
    }
  }

  int _getCategoriaId() {
    if (_librosSeleccionado) return 1;
    if (_ropaSeleccionado) return 2;
    if (_mueblesSeleccionado) return 3;
    if (_computadoresSeleccionado) return 4;
    if (_celularesSeleccionado) return 5;
    if (_vehiculosSeleccionado) return 6;
    return 7;
  }

  int _getTimerMilliseconds() {
    if (_tiempoSeleccionado == 24) return 1440000;
    if (_tiempoSeleccionado == 48) return 2880000;
    return 4320000;
  }

  Future<void> _publicarSubasta() async {
    if (_nombreController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _precioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios')),
      );
      return;
    }

    if (_imagenes.every((img) => img == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes subir al menos una imagen')),
      );
      return;
    }

    setState(() => _publicando = true);

    try {
      final timerId = await TimersService.createTimer(
        _getTimerMilliseconds(),
      );

      final now = DateTime.now();
      final closingDate = now.add(
        Duration(hours: _tiempoSeleccionado),
      );

      final productId = await ProductsService.createProduct(
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        precioMinimo: double.parse(_precioController.text),
        openingDate: now,
        closingDate: closingDate,
        timerId: timerId,
        categoryId: _getCategoriaId(),
      );

      for (final img in _imagenes) {
        if (img != null) {
          await ProductsService.uploadImage(
            image: img,
            productId: productId,
          );
        }
      }

      if (!mounted) return;

      setState(() => _publicando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto publicado correctamente')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _publicando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TituloAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TituloSeccion(texto: 'Publicar producto'),

                  const Text(
                    'Subir fotos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _botonImagen(0),
                      _botonImagen(1),
                      _botonImagen(2),
                    ],
                  ),

                  const Text('Nombre del producto'),
                  CustomTextForm(
                    size: 1,
                    textoPista: 'Computador Asus',
                    controller: _nombreController,
                  ),

                  const Text('Descripción'),
                  CustomTextForm(
                    size: 3,
                    textoPista: 'Asus vivo book...',
                    controller: _descripcionController,
                  ),

                  const Text('Categoría'),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      children: [
                        CustomChipCategory(texto: 'libros', categoriaSeleccionada: _librosSeleccionado, onSelected: (v) => setState(() => _librosSeleccionado = v)),
                        CustomChipCategory(texto: 'ropa', categoriaSeleccionada: _ropaSeleccionado, onSelected: (v) => setState(() => _ropaSeleccionado = v)),
                        CustomChipCategory(texto: 'muebles', categoriaSeleccionada: _mueblesSeleccionado, onSelected: (v) => setState(() => _mueblesSeleccionado = v)),
                        CustomChipCategory(texto: 'computadores', categoriaSeleccionada: _computadoresSeleccionado, onSelected: (v) => setState(() => _computadoresSeleccionado = v)),
                        CustomChipCategory(texto: 'celulares', categoriaSeleccionada: _celularesSeleccionado, onSelected: (v) => setState(() => _celularesSeleccionado = v)),
                        CustomChipCategory(texto: 'vehiculos', categoriaSeleccionada: _vehiculosSeleccionado, onSelected: (v) => setState(() => _vehiculosSeleccionado = v)),
                        CustomChipCategory(texto: 'otros', categoriaSeleccionada: _otrosSeleccionado, onSelected: (v) => setState(() => _otrosSeleccionado = v)),
                      ],
                    ),
                  ),

                  const Text('Duración de la subasta'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(value: 24, groupValue: _tiempoSeleccionado, onChanged: (v) => setState(() => _tiempoSeleccionado = v!)),
                      const Text('24 h'),
                      Radio(value: 48, groupValue: _tiempoSeleccionado, onChanged: (v) => setState(() => _tiempoSeleccionado = v!)),
                      const Text('48 h'),
                      Radio(value: 72, groupValue: _tiempoSeleccionado, onChanged: (v) => setState(() => _tiempoSeleccionado = v!)),
                      const Text('72 h'),
                    ],
                  ),

                  const Text('Precio mínimo'),
                  CustomTextForm(
                    size: 1,
                    textoPista: 'Precio',
                    esNumerico: true,
                    controller: _precioController,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _publicando ? null : _publicarSubasta,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(AppColors.verdeClaro),
                      ),
                      child: const Text('Publicar Subasta', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            if (_publicando)
              Container(
                color: Colors.black.withAlpha(90),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Navigator.pop(context, true),
        backgroundColor: AppColors.verdeClaro.withAlpha(200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Text('X', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _botonImagen(int index) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.verdeClaro,
      child: InkWell(
        onTap: () => _seleccionarImagen(index),
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 90,
          height: 90,
          child: _imagenes[index] == null
              ? const Icon(Icons.add_photo_alternate, size: 40)
              : Image.file(_imagenes[index]!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class CustomChipCategory extends StatelessWidget {
  final String texto;
  final bool categoriaSeleccionada;
  final ValueChanged<bool>? onSelected;

  const CustomChipCategory({super.key, required this.texto, required this.categoriaSeleccionada, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(texto, style: TextStyle(color: categoriaSeleccionada ? Colors.white : Colors.black)),
      selected: categoriaSeleccionada,
      onSelected: onSelected,
      backgroundColor: AppColors.verdeClaro,
      selectedColor: const Color.fromARGB(255, 80, 121, 18),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class CustomTextForm extends StatelessWidget {
  final int size;
  final String textoPista;
  final bool esNumerico;
  final TextEditingController? controller;

  const CustomTextForm({super.key, required this.size, required this.textoPista, this.esNumerico = false, this.controller});

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color.fromARGB(255, 69, 69, 69)),
      borderRadius: BorderRadius.circular(20),
    );

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: textoPista,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        filled: false,
      ),
      maxLines: size,
      minLines: size,
      keyboardType: esNumerico ? TextInputType.number : TextInputType.text,
    );
  }
}

