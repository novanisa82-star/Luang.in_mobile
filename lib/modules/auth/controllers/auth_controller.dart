import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';

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

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan password wajib diisi.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Format email tidak benar.');
      return;
    }

    try {
      isLoading.value = true;

      await authProvider.login(email: email, password: password);

      Get.offAllNamed('/main');
    } catch (e) {
      _showMessage('Login gagal. Periksa email dan password kamu.');
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
      _showMessage('Nama, email, dan password wajib diisi.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Format email tidak benar.');
      return;
    }

    if (password.length < 8) {
      _showMessage('Password minimal 8 karakter.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Konfirmasi password tidak sama.');
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
    _showMessage('Login Google belum dihubungkan ke autentikasi.');
  }

  void _showMessage(String message) {
    Get.snackbar('Informasi', message, snackPosition: SnackPosition.TOP);
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
