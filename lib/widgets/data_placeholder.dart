import 'package:flutter/material.dart';

class DataPlaceholder extends StatelessWidget {
  final String text;
  const DataPlaceholder({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
