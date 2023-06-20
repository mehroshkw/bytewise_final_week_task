import 'package:flutter/material.dart';

class Subheading extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;
  final double letterSpacing;

  const Subheading({super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.left,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.letterSpacing = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
