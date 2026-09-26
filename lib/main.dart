import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luang_in/modules/onboarding/screens/splash_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luang.In',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PalleteColor.primaryPurple,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),

      // Halaman pertama
      home: const SplashScreen(),
    );
  }
}