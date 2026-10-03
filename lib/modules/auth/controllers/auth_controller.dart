import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/main/screens/main_screen.dart';
import 'package:luang_in/modules/onboarding/screens/skill_profile_screen.dart';

class AuthController extends GetxController {
  // Login Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register Controllers
  final regNameController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();

  final isAgreeTerms = false.obs; 

  void toggleTerms(bool? value) {
    isAgreeTerms.value = value ?? false;
  }

  void login() {
    Get.offAll(() => MainScreen());
    
    Get.snackbar(
      'Login Berhasil',
      'Masuk dengan email: ${loginEmailController.text}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void register() {
    if (!isAgreeTerms.value) {
      Get.snackbar(
        'Peringatan',
        'Anda harus menyetujui Syarat dan Ketentuan.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }
    
    Get.off(() => SkillProfileScreen());
    
    Get.snackbar(
      'Registrasi',
      'Pendaftaran berhasil untuk: ${regNameController.text}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void loginWithGoogle() {
    Get.offAll(() => MainScreen());
    
    Get.snackbar(
      'Google SSO',
      'Masuk dengan Akun Google...',
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regNameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    super.onClose();
  }
}