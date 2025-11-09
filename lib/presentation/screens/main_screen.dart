import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:unisubasta_udea_v1/presentation/screens/main/inicio_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/main/mis_subastas_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/main/perfil_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/main/pujar_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/registro_producto_screen.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/shared/titulo_app_bar.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _current_index = 0;

  late List<Widget> _pantallas;
  @override
  void initState() {
    super.initState();
    _pantallas = [
      const InicioScreen(),
      const PujarScreen(),
      const MisSubastasScreen(),
      PerfilScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TituloAppBar(),
      body: _pantallas[_current_index],
      floatingActionButton: _current_index == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroProductoScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.verdeClaro,
              shape: const StadiumBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current_index,
        onTap: (value) {
          setState(() {
            _current_index = value;
          });
        },
        selectedItemColor: AppColors.verdeClaro,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.pan_tool), label: 'Pujar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: 'Mis subastas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
