import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luang_in/core/services/storage_service.dart';
import 'package:luang_in/modules/auth/bindings/auth_binding.dart';
import 'package:luang_in/modules/auth/screens/login_screen.dart';
import 'package:luang_in/modules/auth/screens/register_screen.dart';
import 'package:luang_in/modules/main/screens/main_screen.dart';
import 'package:luang_in/modules/onboarding/screens/onboarding_screen.dart';
import 'package:luang_in/modules/onboarding/screens/skill_profile_screen.dart';
import 'package:luang_in/modules/onboarding/screens/splash_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put<StorageService>(StorageService(), permanent: true);

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
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding1', page: () => const OnboardingScreen()),
        GetPage(
          name: '/LoginScreen',
          page: () => LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          binding: AuthBinding(),
        ),
        GetPage(name: '/skill-profile', page: () => SkillProfileScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/MainScreen', page: () => MainScreen()),
      ],
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const SplashScreen(),
      ),
    );
  }
}
