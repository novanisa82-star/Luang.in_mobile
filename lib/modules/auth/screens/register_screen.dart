import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/app_snackbar.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
          backgroundColor: const Color(0xFFFDC5CE),
          body: Stack(
            children: [
              // Background Gradient with Concentric Arc Waves
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFDC3CB),
                        Color(0xFFDFC6FD),
                        Color(0xFFC3AEFC),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: CustomPaint(painter: ConcentricArcsPainter()),
                ),
              ),

              // Main Layout
              SafeArea(
                child: Column(
                  children: [
                    // Back Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Get.back();
                              } else {
                                Get.off(() => LoginScreen());
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6.0,
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    size: 22,
                                    color: Color(0xFF2D2B3E),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'Back',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2D2B3E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // White Card Bottom Sheet
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 16,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 28.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Create Your Account',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E2D),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF71717A),
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "We're here to help you reach the peaks\nof learning. ",
                                      ),
                                      TextSpan(
                                        text: 'Are you ready?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF27272A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Full Name Field
                                TextField(
                                  controller: controller.nameController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter full name',
                                    prefixIcon: const Icon(
                                        Icons.person_2_outlined,
                                        size: 20,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFA1A1AA),
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE4E4E7),
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFA78BFA),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Email Field
                                TextField(
                                  controller: controller.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1E1E2D),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter email',
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      size: 20,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFA1A1AA),
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE4E4E7),
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFA78BFA),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Password Field
                                Obx(
                                  () => TextField(
                                    controller: controller.passwordController,
                                    obscureText:
                                        controller.obscurePassword.value,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter password',
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        size: 20,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Color(0xFFA1A1AA),
                                        fontSize: 14,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 16,
                                          ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: IconButton(
                                        onPressed: controller.togglePassword,
                                        icon: Icon(
                                          controller.obscurePassword.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF9CA3AF),
                                          size: 20,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE4E4E7),
                                          width: 1.2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFA78BFA),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Forgot Password Link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      AppSnackbar.info(
                                        'Lupa Kata Sandi',
                                        'Fitur pengaturan ulang kata sandi sedang dalam tahap pengembangan.',
                                      );
                                    },
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6B5DE8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Get Started Gradient Button
                                Obx(
                                  () => Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFF9A8B6),
                                          Color(0xFFA78BFA),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFA78BFA,
                                          ).withOpacity(0.35),
                                          blurRadius: 14,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: controller.isLoading.value
                                            ? null
                                            : () {
                                                controller
                                                    .confirmPasswordController
                                                    .text = controller
                                                    .passwordController
                                                    .text;
                                                controller.register();
                                              },
                                        child: Center(
                                          child: controller.isLoading.value
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : const Text(
                                                  'Get Started',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Sign Up With Divider
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Divider(
                                        color: Color(0xFFE5E7EB),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Text(
                                        'Sign up with',
                                        style: TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Color(0xFFE5E7EB),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),

                                // Social Media Button: Google only (Facebook & Apple removed)
                                Center(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: () => controller.loginWithGoogle(),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFE5E7EB),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.04,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: const GoogleLogoWidget(size: 22),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),

                                // Already have an account? Log In
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (Navigator.canPop(context)) {
                                          Get.back();
                                        } else {
                                          Get.off(() => LoginScreen());
                                        }
                                      },
                                      child: const Text(
                                        'Log In',
                                        style: TextStyle(
                                          color: Color(0xFF6B5DE8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: 50.ms)
        .fade(duration: 400.ms)
        .slideY(
          begin: 0.05,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutQuad,
        );
  }
}
