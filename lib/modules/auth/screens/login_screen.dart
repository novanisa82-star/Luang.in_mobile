import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luang_in/utils/app_snackbar.dart';
import '../../auth/controllers/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthController controller;

  final RxBool rememberMe = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller = Get.find<AuthController>();
  }

  @override
  void dispose() {
    rememberMe.close();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    controller.login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: const Color(0xFFFDC5CE),
          body: Stack(
            children: [
              // Background Gradient
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
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Get.back();
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
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

                    // White Card
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
                              horizontal: 24,
                              vertical: 28,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                      letterSpacing: -0.3,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    'Ready to continue your learning journey?\n'
                                    'Your path is right here.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF71717A),
                                      height: 1.4,
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // Email Field
                                  TextFormField(
                                    controller: controller.loginEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                    decoration: _inputDecoration(
                                      hintText: 'Enter email',
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        size: 20,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Email tidak boleh kosong';
                                      }

                                      if (!GetUtils.isEmail(value.trim())) {
                                        return 'Format email tidak valid';
                                      }

                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 14),

                                  // Password Field
                                  Obx(
                                    () => TextFormField(
                                      controller:
                                          controller.loginPasswordController,
                                      obscureText:
                                          controller.obscurePassword.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1E1E2D),
                                      ),
                                      decoration: _inputDecoration(
                                        hintText: 'Password',
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 20,
                                          color: Color(0xFF9CA3AF),
                                        ),
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
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Remember Me & Forgot Password
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => InkWell(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          onTap: rememberMe.toggle,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    border: Border.all(
                                                      color: rememberMe.value
                                                          ? const Color(
                                                              0xFF6B5DE8,
                                                            )
                                                          : const Color(
                                                              0xFFD1D5DB,
                                                            ),
                                                      width: 1.5,
                                                    ),
                                                    color: rememberMe.value
                                                        ? const Color(
                                                            0xFF6B5DE8,
                                                          )
                                                        : Colors.transparent,
                                                  ),
                                                  child: rememberMe.value
                                                      ? const Icon(
                                                          Icons.check,
                                                          size: 13,
                                                          color: Colors.white,
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Remember me',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF4B5563),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
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
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Login Button
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
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          onTap: controller.isLoading.value
                                              ? null
                                              : _handleLogin,
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
                                                    'Log In',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Divider
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
                                          'Sign in with',
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

                                  // Google Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: controller.loginWithGoogle,
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
                                          child: const GoogleLogoWidget(
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 26),

                                  // Sign Up Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 13,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => RegisterScreen());
                                        },
                                        child: const Text(
                                          'Sign Up',
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

  // Reusable Input Decoration

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      errorMaxLines: 2,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE4E4E7), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFA78BFA), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}

// Concentric Arc Painter
class ConcentricArcsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B5CF6).withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width * 0.82, -20);

    for (double r = 40; r < 520; r += 11) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConcentricArcsPainter oldDelegate) {
    return false;
  }
}

// Google Logo Widget
class GoogleLogoWidget extends StatelessWidget {
  final double size;

  const GoogleLogoWidget({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _GoogleLogoPainter());
  }
}

// Google Logo Painter
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final center = Offset(s / 2, s / 2);
    final radius = s * 0.40;
    final strokeWidth = s * 0.20;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Blue Arc
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.2,
      1.2,
      false,
      paint,
    );

    // Green Arc
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.0,
      1.5,
      false,
      paint,
    );

    // Yellow Arc
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.5,
      1.4,
      false,
      paint,
    );

    // Red Arc
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.9,
      1.5,
      false,
      paint,
    );

    // Blue Horizontal Bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(s * 0.46, s * 0.40, s * 0.46, s * 0.20),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleLogoPainter oldDelegate) {
    return false;
  }
}
