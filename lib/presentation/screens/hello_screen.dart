import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:unisubasta_udea_v1/presentation/screens/main_screen.dart';

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return null;
    }
  }

  Future<bool> enviarUsuarioAlBackend(User user) async {
  try {
    final token = await user.getIdToken();
    final url = Uri.parse('http://192.168.30.114:8080/api/users/me');

    // 1. PRIMERO VALIDAMOS SI YA EXISTE
    final getResponse = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // 2. SI YA EXISTE → NO SE MODIFICA NADA
    if (getResponse.statusCode == 200) {
      debugPrint('Usuario ya existe en el backend');
      return true;
    }

    // 3. SI NO EXISTE → SE CREA CON VALORES POR DEFECTO
    if (getResponse.statusCode == 404) {
      final patchResponse = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "descripcionPersonal": "Hola, soy un usuario de Unisubasta",
          "urlFotoPerfil": user.photoURL ?? ""
        }),
      );

      if (patchResponse.statusCode == 200) {
        debugPrint('Usuario creado en el backend');
        return true;
      } else {
        debugPrint('Error creando usuario: ${patchResponse.statusCode}');
        debugPrint(patchResponse.body);
        return false;
      }
    }

    // 4. CUALQUIER OTRO ERROR
    debugPrint('Respuesta inesperada del backend: ${getResponse.statusCode}');
    return false;

  } catch (e) {
    debugPrint('Error de conexión con el backend: $e');
    return false;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.verdeClaro,
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
                "Utiliza tu correo institucional UdeA para hacer parte de esta comunidad",
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
                  backgroundColor: AppColors.verdeOscuro,
                ),
                icon: Image.asset(
                  'lib/presentation/assets/images/Google_Favicon_2025.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Ingresando... espere por favor"),
                    ),
                  );

                  final user = await _signInWithGoogle();
                  if (user == null) return;

                  final permitido = await enviarUsuarioAlBackend(user);

                  if (permitido) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(user: user),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Solo correos institucionales de la UdeA pueden ingresar",
                        ),
                      ),
                    );

                    await _auth.signOut();
                    await _googleSignIn.signOut();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
