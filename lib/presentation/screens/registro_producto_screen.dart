import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_app_bar.dart';

class RegistroProductoScreen extends StatefulWidget {
  const RegistroProductoScreen({super.key});

  @override
  State<RegistroProductoScreen> createState() => _RegistroProductoScreenState();
}

final verdeClaro = const Color(0xff78A614);

class _RegistroProductoScreenState extends State<RegistroProductoScreen> {
  bool _librosSeleccionado = false;
  bool _ropaSeleccionado = false;
  bool _mueblesSeleccionado = false;
  bool _computadoresSeleccionado = false;
  bool _celularesSeleccionado = false;
  bool _vehiculosSeleccionado = false;
  bool _otrosSeleccionado = false;
  int _tiempoSeleccionado = 24;

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const TituloAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Publicar producto',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const Text(
                'Subir fotos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 5,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: verdeClaro,
                    ),
                    child: const Icon(Icons.image, size: 40),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    color: verdeClaro,
                    child: InkWell(
                      onTap: () {
                        print('presionado');
                      },
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      child: const SizedBox(
                        width: 90,
                        height: 90,
                        child: Icon(Icons.add, size: 40),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    color: verdeClaro,
                    child: InkWell(
                      onTap: () {
                        print('presionado');
                      },
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      child: const SizedBox(
                        width: 90,
                        height: 90,
                        child: Icon(Icons.add, size: 40),
                      ),
                    ),
                  ),
                ],
              ),
              const Text('Nombre del producto'),
              const CustomTextForm(size: 1, textoPista: 'Computador Asus'),
              const Text('Descripción'),
              const CustomTextForm(
                size: 3,
                textoPista:
                    'Asus vivo book, con ryzen 5, 1 tera de espacio, ...',
              ),

              const Text('Categoría'),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5,
                  children: [
                    CustomChipCategory(
                      texto: 'libros',
                      categoriaSeleccionada: _librosSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _librosSeleccionado = value;
                        });
                      },
                    ),
                    CustomChipCategory(
                      texto: 'ropa',
                      categoriaSeleccionada: _ropaSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _ropaSeleccionado = value;
                        });
                      },
                    ),
                    CustomChipCategory(
                      texto: 'muebles',
                      categoriaSeleccionada: _mueblesSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _mueblesSeleccionado = value;
                        });
                      },
                    ),
                    CustomChipCategory(
                      texto: 'computadores',
                      categoriaSeleccionada: _computadoresSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _computadoresSeleccionado = value;
                        });
                      },
                    ),
                    CustomChipCategory(
                      texto: 'celulares',
                      categoriaSeleccionada: _celularesSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _celularesSeleccionado = value;
                        });
                      },
                    ),
                    CustomChipCategory(
                      texto: 'vehiculos',
                      categoriaSeleccionada: _vehiculosSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _vehiculosSeleccionado = value;
                        });
                      },
                    ),
                    CustomChipCategory(
                      texto: 'otros',
                      categoriaSeleccionada: _otrosSeleccionado,
                      onSelected: (value) {
                        setState(() {
                          _otrosSeleccionado = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Text('Duración de la subasta'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: verdeClaro,
                        value: 24,
                        groupValue: _tiempoSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            _tiempoSeleccionado = value!;
                          });
                        },
                      ),
                      const Text('24 h'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: verdeClaro,
                        value: 48,
                        groupValue: _tiempoSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            _tiempoSeleccionado = value!;
                          });
                        },
                      ),
                      const Text('48 h'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        activeColor: verdeClaro,
                        value: 72,
                        groupValue: _tiempoSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            _tiempoSeleccionado = value!;
                          });
                        },
                      ),
                      const Text('72 h'),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(verdeClaro),
                  ),
                  child: const Text(
                    'Publicar Subasta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: verdeClaro,
        backgroundColor: Colors.transparent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.pan_tool), label: 'Pujar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: 'Sub',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class CustomChipCategory extends StatelessWidget {
  final String texto;
  final bool categoriaSeleccionada;
  final ValueChanged<bool>? onSelected;

  const CustomChipCategory({
    super.key,
    required this.texto,
    required this.categoriaSeleccionada,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        texto,
        style: TextStyle(
          color: categoriaSeleccionada ? Colors.white : Colors.black,
        ),
      ),
      selected: categoriaSeleccionada,
      onSelected: onSelected,
      backgroundColor: verdeClaro,
      selectedColor: const Color.fromARGB(255, 80, 121, 18),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
    );
  }
}

class CustomTextForm extends StatelessWidget {
  final int size;
  final String textoPista;

  const CustomTextForm({
    super.key,
    required this.size,
    required this.textoPista,
  });

  @override
  Widget build(BuildContext context) {
    // final TextEditingController textController = TextEditingController();
    // final FocusNode focusNode = FocusNode();

    final outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    );

    final InputDecoration inputDecoration = InputDecoration(
      hintText: textoPista,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: false,
    );
    return TextFormField(
      decoration: inputDecoration,
      maxLines: size,
      minLines: size,
    );
  }
}
