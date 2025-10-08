import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/screens/hello_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  bool esUdea(String? correo) {
    if (correo != null) {
      if (correo.contains('udea.edu.co')) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!esUdea(user.email)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HelloScreen()),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('login exitosoo'),
        backgroundColor: const Color(0xFF78A614),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HelloScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          if (user.photoURL != null)
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          const SizedBox(height: 20),
          Text(
            'Estudiante: ${user.displayName}',
            style: const TextStyle(fontSize: 18),
          ),
          Text('otros ${user.email}'),
        ],
      ),
    );
  }
}
