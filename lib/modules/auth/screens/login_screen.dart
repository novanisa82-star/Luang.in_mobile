import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luang_in/modules/main/screens/main_screen.dart';
import '../../../utils/pallete_color.dart';
import '../../auth/controllers/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child:
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: PalleteColor.lightPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LI',
                          style: TextStyle(
                            color: PalleteColor.primaryPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Selamat Datang Kembali',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PalleteColor.textDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Masuk untuk mengelola pekerjaan dan pelamar Anda.',
                        style: TextStyle(
                          fontSize: 14,
                          color: PalleteColor.textGrey,
                        ),
                      ),

                      const SizedBox(height: 32),

                      OutlinedButton(
                        onPressed: () => controller.loginWithGoogle(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(
                            color: PalleteColor.borderColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.g_mobiledata,
                              color: PalleteColor.googleRed,
                              size: 30,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Masuk dengan Google',
                              style: TextStyle(
                                color: PalleteColor.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: PalleteColor.borderColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'ATAU EMAIL',
                              style: TextStyle(
                                color: PalleteColor.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: PalleteColor.borderColor),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Alamat Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: PalleteColor.textDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: controller.loginEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'nama@gmail.com',
                          hintStyle: const TextStyle(
                            color: PalleteColor.textGrey,
                          ),
                          filled: true,
                          fillColor: PalleteColor.inputBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: PalleteColor.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: PalleteColor.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: PalleteColor.primaryPurple,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kata Sandi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: PalleteColor.textDark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Lupa?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: PalleteColor.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: controller.loginPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          hintStyle: const TextStyle(
                            color: PalleteColor.textGrey,
                          ),
                          filled: true,
                          fillColor: PalleteColor.inputBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: PalleteColor.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: PalleteColor.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: PalleteColor.primaryPurple,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            try {
                              debugPrint('1. TOMBOL MASUK DITEKAN');
                              Get.offAll(() => MainScreen());
                              debugPrint('2. Get.offAll DIPANGGIL');
                            } catch (e, stackTrace) {
                              debugPrint('ERROR NAVIGASI: $e');
                              debugPrint('STACKTRACE: $stackTrace');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PalleteColor.primaryPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: PalleteColor.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun? ',
                            style: TextStyle(
                              color: PalleteColor.textGrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(() => RegisterScreen()),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: PalleteColor.primaryPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  .animate(delay: 50.ms)
                  .fade(duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutQuad,
                  ),
        ),
      ),
    );
  }
}