import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisubasta_udea_v1/presentation/screens/chat/chat_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/hello_screen.dart';
import 'package:unisubasta_udea_v1/data/services/user_service.dart';
import 'package:unisubasta_udea_v1/data/services/products_service.dart';
import 'package:unisubasta_udea_v1/data/services/bid_service.dart';

class PerfilScreen extends StatefulWidget {
  final User user;
  const PerfilScreen({super.key, required this.user});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? perfil;

  int subastasCreadas = 0;
  int pujasRealizadas = 0;
  int subastasGanadas = 0; // lo dejas en 0 como pediste

  bool cargandoContadores = true;

  User get user => widget.user;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
    cargarContadores();
  }

  // ===========================
  // CARGA DE DESCRIPCIÓN Y PERFIL
  // ===========================
  Future<void> cargarPerfil() async {
    try {
      final data = await UserService.getUserProfile(user);
      setState(() {
        perfil = data;
      });
    } catch (e) {
      debugPrint('Error cargando perfil: $e');
    }
  }

  Future<void> actualizarDescripcion(String nuevaDescripcion) async {
    final ok = await UserService.updateDescripcion(user, nuevaDescripcion);

    if (ok) {
      await cargarPerfil();
    } else {
      debugPrint('Error actualizando descripción');
    }
  }

  // ===========================
  // NUEVA LÓGICA: SUBASTAS Y PUJAS
  // ===========================
  Future<void> cargarContadores() async {
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) return;

      final sellerId = await ProductsService.getMyUserId();
      if (sellerId == null) return;

      // Subastas creadas
      final productos = await ProductsService.getProductsBySeller(sellerId);
      subastasCreadas = productos.length;

      // Pujas realizadas
      final bids = await BidService.getMyBids(authUser);
      pujasRealizadas = bids.length;

      setState(() {
        cargandoContadores = false;
      });
    } catch (e) {
      debugPrint("Error cargando contadores: $e");
      setState(() {
        cargandoContadores = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: perfil == null || cargandoContadores
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: (user.photoURL != null)
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.photoURL!),
                          )
                        : const CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.verdeClaro,
                            child:
                                Icon(Icons.person, size: 80, color: Colors.white),
                          ),
                  ),

                  const SizedBox(height: 5),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      user.displayName ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '@${user.email}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BloqueCantidadSubastas(
                        numero: subastasCreadas,
                        texto1: 'Subastas',
                        texto2: 'creadas',
                      ),
                      BloqueCantidadSubastas(
                        numero: pujasRealizadas,
                        texto1: 'Pujas',
                        texto2: 'realizadas',
                      ),
                      BloqueCantidadSubastas(
                        numero: subastasGanadas,
                        texto1: 'Subastas',
                        texto2: 'ganadas',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Calificación:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),

                  Row(
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (context, index) {
                          return const Icon(Icons.star_rounded, color: Colors.amber);
                        },
                        itemCount: 5,
                        rating: (perfil!['reputacionPromedio'] ?? 0).toDouble(),
                        itemSize: 26,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${perfil!['reputacionPromedio'] ?? 0}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Acerca de mí',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  EditableTextField(
                    descripcion: perfil!['descripcionPersonal'] ?? '',
                    onGuardar: actualizarDescripcion,
                  ),

                  const CustomBotonPerfil(texto: 'Mensajes'),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelloScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.verdeClaro),
                        ),
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/* ===================== COMPONENTES ===================== */

class CustomBotonPerfil extends StatelessWidget {
  final String texto;
  const CustomBotonPerfil({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        splashColor: AppColors.verdeClaro.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: const Border(bottom: BorderSide(width: 0.3)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(texto), const Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ),
    );
  }
}

class BloqueCantidadSubastas extends StatelessWidget {
  final int numero;
  final String texto1;
  final String texto2;
  const BloqueCantidadSubastas({
    super.key,
    required this.numero,
    required this.texto1,
    required this.texto2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$numero',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        Text(
          texto1,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
        Text(
          texto2,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ],
    );
  }
}

class EditableTextField extends StatefulWidget {
  final String descripcion;
  final Function(String) onGuardar;

  const EditableTextField({
    super.key,
    required this.descripcion,
    required this.onGuardar,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.descripcion);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 69, 69, 69)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _isEditing
                  ? TextFormField(
                      controller: _controller,
                      autofocus: true,
                      maxLines: 3,
                      minLines: 3,
                    )
                  : Text(
                      _controller.text,
                      style: const TextStyle(fontSize: 15),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            if (_isEditing) {
              await widget.onGuardar(_controller.text);
            }
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          icon: _isEditing ? const Icon(Icons.check) : const Icon(Icons.edit),
        ),
      ],
    );
  }
}
