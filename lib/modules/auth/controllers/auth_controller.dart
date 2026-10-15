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
      _showMessage(_errorMessage(e));
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

    if (password != confirmPassword) {
      _showMessage('Konfirmasi password tidak sama.');
      return;
    }

    try {
      isLoading.value = true;

      await authProvider.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        whatsapp: whatsappController.text.trim().isEmpty
            ? null
            : whatsappController.text.trim(),
        domisili: domisiliController.text.trim().isEmpty
            ? null
            : domisiliController.text.trim(),
      );

      Get.offAllNamed('/main');
    } catch (e) {
      _showMessage(_errorMessage(e));
    } finally {
      isLoading.value = false;
    }
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

  String _errorMessage(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');

    if (message.contains('email') &&
        (message.contains('valid') || message.contains('format'))) {
      return 'Format email tidak benar.';
    }

    return message;
  }

  void _showMessage(String message) {
    Get.snackbar(
      'Informasi',
      message,
      snackPosition: SnackPosition.TOP,
    );
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