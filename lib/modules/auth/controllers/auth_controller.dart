import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../utils/app_snackbar.dart';
import 'package:luang_in/core/config/api_config.dart';

class AuthController extends GetxController {
  final AuthProvider authProvider;

  AuthController(this.authProvider);

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  final nameController = TextEditingController();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final whatsappController = TextEditingController();
  final domisiliController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[\w.!#$%&’*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$',
    ).hasMatch(email);
  }

  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    debugPrint('==================================================');
    debugPrint('🚀 [AUTH LOGIN TRIGGERED]');
    debugPrint('📧 Email Input: "$email"');
    debugPrint('🔑 Password length: ${password.length} karakter');
    debugPrint('🌐 Target Endpoint: ${ApiConfig.login}');
    debugPrint('==================================================');

    if (email.isEmpty || password.isEmpty) {
      debugPrint('⚠️ [LOGIN DIBATALKAN] Email atau password kosong.');
      AppSnackbar.warning('Perhatian', 'Email dan kata sandi wajib diisi.');
      return;
    }

    if (!_isValidEmail(email)) {
      debugPrint('⚠️ [LOGIN DIBATALKAN] Format email tidak valid: "$email"');
      AppSnackbar.warning('Perhatian', 'Format alamat email belum sesuai.');
      return;
    }

    try {
      isLoading.value = true;

      debugPrint('⏳ [MENGIRIM REQUEST KE BACKEND...]');
      final user = await authProvider.login(email: email, password: password);

      debugPrint('🎉 [LOGIN BERHASIL!] User: ${user.name} (${user.email})');
      Get.offAllNamed('/main');
    } catch (e, stack) {
      debugPrint('❌ [LOGIN GAGAL - DETAIL ERROR]');
      debugPrint('⚠️ Pesan Error: $e');
      debugPrint('🔍 Tipe Error: ${e.runtimeType}');
      debugPrint('📜 Stack Trace singkat:\n$stack');

      AppSnackbar.showError(
        e,
        title: 'Gagal Masuk',
        defaultMessage: 'Email atau kata sandi tidak sesuai. Silakan periksa kembali.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      AppSnackbar.warning('Perhatian', 'Nama lengkap, email, dan kata sandi wajib diisi.');
      return;
    }

    if (!_isValidEmail(email)) {
      AppSnackbar.warning('Perhatian', 'Format alamat email belum sesuai.');
      return;
    }

    if (password.length < 8) {
      AppSnackbar.warning('Perhatian', 'Kata sandi minimal terdiri dari 8 karakter.');
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.warning('Perhatian', 'Konfirmasi kata sandi tidak cocok.');
      return;
    }

    Get.toNamed(
      '/skill-profile',
      arguments: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );
  }

  void togglePassword() {
    obscurePassword.toggle();
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword.toggle();
  }

  Future<void> loginWithGoogle() async {
    AppSnackbar.info('Segera Hadir', 'Fitur masuk dengan Google sedang dalam proses integrasi.');
  }

  @override
  void onClose() {
    nameController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    whatsappController.dispose();
    domisiliController.dispose();

    super.onClose();
  }
}
