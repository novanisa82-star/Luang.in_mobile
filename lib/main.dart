import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luang_in/modules/auth/screens/login_screen.dart';
import 'package:luang_in/modules/auth/screens/register_screen.dart';
import 'package:luang_in/modules/main/screens/main_screen.dart';
import 'package:luang_in/modules/onboarding/screens/onboarding1_screen.dart';
import 'package:luang_in/modules/onboarding/screens/onboarding2_screen.dart';
import 'package:luang_in/modules/onboarding/screens/skill_profile_screen.dart';
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

      // Named routes untuk Flutter Web (URL routing)
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding1', page: () => const OnboardingScreen1()),
        GetPage(name: '/onboarding2', page: () => const OnboardingScreen2()),
        GetPage(name: '/LoginScreen', page: () => LoginScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/skill-profile', page: () => SkillProfileScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
      ],

      // Fallback kalau route tidak ditemukan
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const SplashScreen(),
      ),
    );
  }
}