import 'package:flutter/material.dart';

class TituloSeccion extends StatelessWidget {
  final String texto;

  const TituloSeccion({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }
}
