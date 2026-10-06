import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/auth/screens/login_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';
import 'package:lottie/lottie.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Navigasi ke halaman login
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
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
                    onPressed: () {
                      Get.offAll(() => LoginScreen());
                    },
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
                    illustration: const Center(
                      child: Icon(
                        Icons.rocket_launch,
                        size: 100,
                        color: PalleteColor.primaryPurple,
                      ),
                    ),
                    title: 'Mulai Sekarang',
                    description:
                        'Bergabunglah dan temukan pekerjaan yang sesuai dengan kemampuan kamu bersama Luang.In.',
                  ),
                ],
              ),
            ),

            // Indikator halaman
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

            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 32.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalleteColor.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          controller.currentPage.value == 2
                              ? 'Mulai Sekarang'
                              : 'Lanjut',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: PalleteColor.textDark,
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
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

  Widget _buildDot({
    required int index,
    required int currentPage,
  }) {
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

  Widget _buildPage1Illustration() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Lottie.asset(
          'assets/lottie/Search.json',
          width: 150,
          height: 150,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildPage2Illustration() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F4FF),
                shape: BoxShape.circle,
              ),
            ),

            const Icon(
              Icons.smart_toy_rounded,
              size: 110,
              color: PalleteColor.primaryPurple,
            ),

            Positioned(
              top: 65,
              right: 65,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: PalleteColor.primaryPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tips tersedia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: PalleteColor.primaryPurple.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.bolt,
                      size: 16,
                      color: Color(0xFFFF9800),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Pencocokan AI 24/7',
                      style: TextStyle(
                        color: PalleteColor.primaryPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
}
