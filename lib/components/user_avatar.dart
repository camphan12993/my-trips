import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  const UserAvatar({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            name,
            style: const TextStyle(fontSize: 10, color: Colors.white, height: 1),
          ),
        ),
      ),
    );
  }
}
