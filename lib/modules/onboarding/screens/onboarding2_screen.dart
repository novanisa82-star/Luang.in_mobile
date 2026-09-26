import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/utils/pallete_color.dart';

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
      // TODO: Navigasi ke halaman login/utama
      // Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'WorkLoop',
                    style: TextStyle(
                      color: PalleteColor.primaryPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Aksi Skip
                    },
                    child: Text(
                      'Skip',
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
                    title: 'Find Nearest Gigs',
                    description: 'Discover flexible freelance and hourly shifts right around your neighborhood with live GPS radius tracking.',
                  ),
                  _buildOnboardingPage(
                    illustration: _buildPage2Illustration(),
                    title: 'Chatbot Assistant',
                    description: 'Meet your smart AI career co-pilot. Get instant gig recommendations, profile polish, and personalized interview prep.',
                  ),
                  _buildOnboardingPage(
                    illustration: const Center(
                      child: Icon(Icons.rocket_launch, size: 100, color: PalleteColor.primaryPurple),
                    ),
                    title: 'Get Started Now',
                    description: 'Join the community and start your journey with WorkLoop today.',
                  ),
                ],
              ),
            ),
            
            // Indikator dibungkus Obx agar reaktif
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => _buildDot(
                  index: index, 
                  currentPage: controller.currentPage.value,
                ),
              ),
            )),
            
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 32.0),
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
                      // Teks tombol dibungkus Obx agar berubah di halaman terakhir
                      Obx(() => Text(
                        controller.currentPage.value == 2 ? 'Get Started' : 'Next Step',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )),
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

  Widget _buildOnboardingPage({required Widget illustration, required String title, required String description}) {
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

  Widget _buildDot({required int index, required int currentPage}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: currentPage == index ? 24 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? PalleteColor.primaryPurple : const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildPage1Illustration() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 260, height: 260, decoration: const BoxDecoration(color: Color(0xFFF8F4FF), shape: BoxShape.circle)),
            Container(width: 170, height: 170, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFEBE0FF), width: 1.5))),
            Container(width: 110, height: 110, decoration: const BoxDecoration(color: Color(0xFFF0E5FF), shape: BoxShape.circle)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, size: 65, color: PalleteColor.primaryPurple),
                Icon(Icons.person, size: 45, color: PalleteColor.primaryPurple),
              ],
            ),
            Positioned(
              top: 30, right: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
                child: Row(
                  children: const [
                    Icon(Icons.near_me, size: 14, color: PalleteColor.primaryPurple),
                    SizedBox(width: 4),
                    Text('0.8 km away', style: TextStyle(color: PalleteColor.primaryPurple, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
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
            Container(width: 260, height: 260, decoration: const BoxDecoration(color: Color(0xFFF8F4FF), shape: BoxShape.circle)),
            const Icon(Icons.smart_toy_rounded, size: 110, color: PalleteColor.primaryPurple),
            Positioned(
              top: 65, right: 65,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: PalleteColor.primaryPurple, borderRadius: BorderRadius.circular(12)),
                child: const Text('Tips ready', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: PalleteColor.primaryPurple.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.bolt, size: 16, color: Color(0xFFFF9800)),
                    SizedBox(width: 6),
                    Text('24/7 AI Smart Matching', style: TextStyle(color: PalleteColor.primaryPurple, fontSize: 12, fontWeight: FontWeight.w600)),
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