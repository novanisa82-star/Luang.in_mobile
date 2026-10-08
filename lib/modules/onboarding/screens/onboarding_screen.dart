import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:luang_in/modules/auth/screens/login_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAll(
        () => LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    }
  }

  void skipOnboarding() {
    Get.offAll(
      () => LoginScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(OnboardingController(), permanent: false);
  }

  @override
  void dispose() {
    if (Get.isRegistered<OnboardingController>()) {
      Get.delete<OnboardingController>();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Luang.In',
                    style: TextStyle(
                      color: PalleteColor.primaryPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                        color: PalleteColor.textGrey.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Halaman onboarding
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  _buildOnboardingPage(
                    illustration: _buildPage1Illustration(),
                    title: 'Cari Kerja Terdekat',
                    description:
                        'Temukan pekerjaan fleksibel dan kerja harian di sekitar kamu dengan bantuan lokasi GPS secara langsung.',
                  ),

                  _buildOnboardingPage(
                    illustration: _buildPage2Illustration(),
                    title: 'Asisten Chatbot AI',
                    description:
                        'Dapatkan rekomendasi pekerjaan yang sesuai, tips untuk meningkatkan profil, dan persiapan wawancara kerja.',
                  ),

                  _buildOnboardingPage(
                    illustration: _buildPage3Illustration(),
                    title: 'Mulai Sekarang',
                    description:
                        'Bergabunglah dan temukan pekerjaan yang sesuai dengan kemampuan kamu bersama Luang.In.',
                  ),
                ],
              ),
            ),

            // Indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => _buildDot(
                    index: index,
                    currentPage: controller.currentPage.value,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tombol
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalleteColor.primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.currentPage.value == 2
                              ? 'Mulai Sekarang'
                              : 'Lanjut',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
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
    );
  }

  Widget _buildOnboardingPage({
    required Widget illustration,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        Expanded(child: illustration),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: PalleteColor.textDark,
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: PalleteColor.textGrey,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDot({required int index, required int currentPage}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: currentPage == index ? 24 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? PalleteColor.primaryPurple
            : const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // Page 1
  Widget _buildPage1Illustration() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Lottie.asset(
          'assets/lottie/Search.json',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }

  // Page 2
  Widget _buildPage2Illustration() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Bulatan utama
            Container(
              width: 225,
              height: 225,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFF7F0FF), const Color(0xFFEDE1FF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: PalleteColor.primaryPurple.withOpacity(0.12),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),

            // Bulatan kecil dekorasi
            Positioned(
              top: 25,
              left: 30,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: PalleteColor.primaryPurple.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: 45,
              right: 25,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: PalleteColor.primaryPurple.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Chatbot
            Lottie.asset(
              'assets/lottie/chatbot.json',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
              repeat: true,
            ),

            // Badge AI Online
            Positioned(
              top: 35,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 7,
                      height: 7,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text(
                      'AI Online',
                      style: TextStyle(
                        color: PalleteColor.primaryPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge rekomendasi
            Positioned(
              bottom: 30,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 15,
                      color: PalleteColor.primaryPurple,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Rekomendasi AI',
                      style: TextStyle(
                        color: PalleteColor.primaryPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page 3
  Widget _buildPage3Illustration() {
    return Center(
      child: Lottie.asset(
        'assets/lottie/roket.json',
        width: 250,
        height: 250,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}
