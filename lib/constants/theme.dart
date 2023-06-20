import 'dart:math';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

ThemeData theme() {
  return ThemeData(
      primaryColor: AppColors.primaryColor,
      primarySwatch: const MaterialColor(0xFF223947, <int, Color>{
        1000:Color(0xFF223947),
        900: Color(0xFF384d59),
        800: Color(0xFF4e616c),
        700: Color(0xFF64747e),
        600: Color(0xFF7a8891),
        500: Color(0xFF919ca3),
        400: Color(0xFFa7b0b5),
        300: Color(0xFFbdc4c8),
        200: Color(0xFFd3d7da),
        100: Color(0xFFe9ebed),
        50: Color(0xFFffffff),
      }),
      scaffoldBackgroundColor: Colors.white,
      textTheme: textTheme());
}

TextTheme textTheme() {
  return const TextTheme(
      headline1: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        // fontFamily: "Roboto",
      ),
      headline2: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        // fontFamily: "Roboto",
      ),
      headline3: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // fontFamily: "Roboto",
      ),
      headline4: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        // fontFamily: "Roboto",
      ),
      headline6: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        // fontFamily: "Roboto",
      ),
      bodyText2: TextStyle(
        color: AppColors.primaryWhite,
        fontSize: 10,
        fontWeight: FontWeight.normal,
        // fontFamily: "Roboto",
      ));
}
