import 'package:flutter/material.dart';

class PalleteColor {
  static const Color primaryColor = Color(0xFFE0E0E0);
  static const Color secondaryColor = Color(0xFFE0E0E0);
  static const Color primaryPurple = Color(0xFF8833E6);
  static const Color textDark = Color(0xFF1E1E2D);
  static const Color textGrey = Color(0xFF8A8A9D);
  
  static const Color lightPurple = Color(0xFFEFE7FE); 
  static const Color inputBackground = Color(0xFFF8FAFC); 
  static const Color borderColor = Color(0xFFE2E8F0); 
  static const Color white = Color(0xFFFFFFFF);
  static const Color googleRed = Color(0xFFEA4335); 

  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color(0xFF8833E6), 
      Color(0xFF5C16C5), 
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}