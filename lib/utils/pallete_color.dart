import 'package:flutter/material.dart';

class PalleteColor {
  static const Color primaryColor = Color(0xFFE0E0E0);
  static const Color secondaryColor = Color(0xFFE0E0E0);
  static const Color primaryPurple = Color(0xFF8833E6);
  static const Color textDark = Color(0xFF1E1E2D);
  static const Color textGrey = Color(0xFF8A8A9D);

  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color(0xFF8833E6), 
      Color(0xFF5C16C5), 
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}