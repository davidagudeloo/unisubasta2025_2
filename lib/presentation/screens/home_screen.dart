import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/screens/hello_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/registro_producto_screen.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_app_bar.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  // bool esUdea(String? correo) {
  //   if (correo != null) {
  //     if (correo.contains('gmail.com')) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    // if (!esUdea(user.email)) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const HelloScreen()),
    //     );
    //   });
    // }
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('login exitosoo'),
      //   backgroundColor: const Color(0xFF78A614),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         FirebaseAuth.instance.signOut();
      //         // Navigator.pop(context);
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => const HelloScreen()),
      //         );
      //       },
      //       icon: const Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      appBar: const TituloAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: (user.photoURL != null)
                    ? CircleAvatar(
                        foregroundColor: Colors.red,
                        radius: 40,
                        backgroundImage: NetworkImage(user.photoURL!),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundColor: verdeClaro,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${user.displayName}',
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
              SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BloqueCantidadSubastas(
                    numero: 12,
                    texto1: 'Subastas',
                    texto2: 'creadas',
                  ),
                  BloqueCantidadSubastas(
                    numero: 34,
                    texto1: 'Pujas',
                    texto2: 'realizadas',
                  ),
                  BloqueCantidadSubastas(
                    numero: 8,
                    texto1: 'Subastas',
                    texto2: 'ganadas',
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroProductoScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(verdeClaro),
                    ),
                    child: const Text(
                      'Editar descripción',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Text(
                'Acerca de mí',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Estudiante de Ingeniería de Sistemas en el semestre 8',
                  ),
                ),
              ),
              const CustomBotonPerfil(texto: 'Mensajes'),
              const CustomBotonPerfil(texto: 'Ajustes'),
              const CustomBotonPerfil(texto: 'Favoritos'),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelloScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(verdeClaro),
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

class CustomBotonPerfil extends StatelessWidget {
  final String texto;
  const CustomBotonPerfil({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: verdeClaro.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: const Border(bottom: BorderSide(width: 0.6)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('$texto'), const Icon(Icons.arrow_forward_ios)],
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
    return SizedBox(
      child: Column(
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
      ),
    );
  }
}
