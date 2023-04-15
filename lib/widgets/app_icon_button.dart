import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Icon icon;
  final Function()? onTap;
  final double size;
  const AppIconButton(this.icon, {super.key, this.onTap, this.size = 20});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), spreadRadius: -2, blurRadius: 24),
          ],
        ),
        child: icon,
      ),
    );
  }
}
