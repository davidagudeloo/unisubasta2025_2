import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:unisubasta_udea_v1/presentation/screens/trash/home_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/main_screen.dart';
import 'package:unisubasta_udea_v1/presentation/screens/registro_producto_screen.dart';
//impm

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
    }
  }

  // bool esUdea(String? correo) {
  //   if (correo != null) {
  //     if (correo.contains('udea.edu.co')) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.verdeClaro,
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
                  backgroundColor: AppColors.verdeOscuro,
                ),
                icon: Image.asset(
                  'lib/presentation/assets/images/Google_Favicon_2025.png',
                  width: 24,
                  height: 24,
                ),
                // icon: const Icon(Icons.mail, color: Colors.white),
                onPressed: () async {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Ingresando...")),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text("Ingresando... espere  por favor"),
                    ),
                  );
                  final user = await _signInWithGoogle();
                  if (user != null) {
                    // print("DEBUG → Email obtenido: ${user.email}");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(user: user),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Google sign-in ha fallado'),
                      ),
                    );
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
