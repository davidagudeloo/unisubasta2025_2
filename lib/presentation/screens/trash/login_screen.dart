import 'package:flutter/material.dart';

//impm
//stles o stful
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unisubasta")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "Login with google  ",
              style: TextStyle(fontSize: 160, fontWeight: FontWeight.w100),
            ),
            const Text(
              "solo se aceptan cuentas de la Universidad de Antioquia",
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ingresando... espere  por favor"),
                  ),
                );
              },
              child: const Text("Login udea account"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.login),
      ),
    );
  }
}
