import 'package:flutter/material.dart';

class TituloAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TituloAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Image.asset(
          'lib/presentation/assets/images/martillo_logo.png',
          height: 24,
          width: 24,
        ),
      ),
      title: const Text(
        'UniSubasta',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
