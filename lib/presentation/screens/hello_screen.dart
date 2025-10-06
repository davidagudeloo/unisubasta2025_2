import 'package:flutter/material.dart';
//impm

class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF78A614),
      // appBar: AppBar(title: const Text("hola")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/presentation/assets/images/unisubasta_logo_bienvenida.png",
                height: 200,
                width: 200,
              ),
              const Text(
                "Bienvenido a Unisubasta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              const Text(
                "Utiliza tu correo institucional para hacer parte de esta comunidad",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              ElevatedButton.icon(
                label: const Text(
                  "Continúa con Google",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A4009),
                ),
                icon: const Icon(Icons.mail, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ingresando...")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
