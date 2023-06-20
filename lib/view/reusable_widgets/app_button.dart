import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final double elevation;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.borderColor = Colors.transparent,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Text(label,style: Theme.of(context).textTheme.bodyText1,),
    );
  }
}
