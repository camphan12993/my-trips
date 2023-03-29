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
        width: size,
        height: size,
        decoration: BoxDecoration(border: Border.all(color: Colors.blue), shape: BoxShape.circle),
        child: icon,
      ),
    );
  }
}
