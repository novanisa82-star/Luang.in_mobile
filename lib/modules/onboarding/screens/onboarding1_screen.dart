import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/onboarding/screens/onboarding2_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1 ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
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
                      // Aksi ketika tombol Skip ditekan
                    },
                    child: Text(
                      'Skip',
                      style: GoogleFonts.plusJakartaSans(
                        color: PalleteColor.primaryPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )
                    ),
                  ),
                ],
              ),
            ),

            // --- ILUSTRASI TENGAH ---
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lingkaran Latar Belakang Paling Besar
                      Container(
                        width: 260,
                        height: 260,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F4FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      
                      // Garis Putus-putus (Simulasi dengan border tipis)
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEBE0FF),
                            width: 1.5,
                          ),
                        ),
                      ),

                      // Lingkaran Latar Belakang Dalam
                      Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0E5FF),
                          shape: BoxShape.circle,
                        ),
                      ),

                      // Ikon Pin Lokasi dan Profil (Ditumpuk di tengah)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 65,
                            color: PalleteColor.primaryPurple,
                          ),
                          Icon(
                            Icons.person,
                            size: 45,
                            color: PalleteColor.primaryPurple,
                          ),
                        ],
                      ),

                      // Floating Badge "0.8 km away"
                      Positioned(
                        top: 30,
                        right: 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
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
                            children: [
                              const Icon(
                                Icons.near_me,
                                size: 14,
                                color: PalleteColor.primaryPurple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '0.8 km away',
                                style: GoogleFonts.plusJakartaSans(
                                  color: PalleteColor.primaryPurple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- PAGE INDICATOR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 6,
                  decoration: BoxDecoration(
                    color: PalleteColor.primaryPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E5EA),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E5EA),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- TEKS JUDUL & DESKRIPSI ---
            Text(
              'Find Nearest Gigs',
              style: GoogleFonts.plusJakartaSans(
                color: PalleteColor.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              )
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Discover flexible freelance and hourly shifts right around your neighborhood with live GPS radius tracking.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: PalleteColor.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
              ),
            ),
            
            const SizedBox(height: 48),

            // --- TOMBOL BAWAH ---
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 32.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const OnboardingScreen2());
                  },
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
                      Text(
                        'Next Step',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(width: 8),
                      Icon(
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
}