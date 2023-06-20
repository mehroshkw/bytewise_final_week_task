import 'package:flutter/material.dart';

class AppHeading extends StatelessWidget {
  final String text;
  final Color textColor;

  const AppHeading({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}