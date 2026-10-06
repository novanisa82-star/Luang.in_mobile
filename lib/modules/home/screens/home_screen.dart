import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/pallete_color.dart';

class HomeController extends GetxController {
  var selectedCategory = 0.obs;

  final categories = [
    'Semua (18)',
    'Layanan F&B',
    'Upah Tinggi (Rp450rb+/hari)',
    'Hari Ini'
  ];

  final gigs = [
    {
      'tag': 'Mitra Barista',
      'tagColor': const Color(0xFF8833E6),
      'tagBg': const Color(0xFFEFE7FE),
      'price': 'Rp525.000',
      'unit': '/shift',
      'title': 'Kopi Kenangan Senopati',
      'distance': '1,2 km dari sini',
      'duration': 'Shift: 4 Jam',
      'time': 'Mulai Hari Ini, 16:00',
    },
    {
      'tag': 'Tim Acara',
      'tagColor': const Color(0xFFD97706),
      'tagBg': const Color(0xFFFEF3C7),
      'price': 'Rp900.000',
      'unit': '/hari',
      'title': 'Penyelenggara Pasar Pop-up',
      'distance': '2,4 km dari sini',
      'duration': 'Kerja 1 Hari',
      'time': 'Besok Pagi',
    },
    {
      'tag': 'Pembantu Gudang',
      'tagColor': const Color(0xFF059669),
      'tagBg': const Color(0xFFD1FAE5),
      'price': 'Rp720.000',
      'unit': '/shift',
      'title': 'Gudang Logistik Paxel',
      'distance': '3,1 km dari sini',
      'duration': 'Shift Malam',
      'time': 'Malam Ini, 21:00',
    },
  ];

  void changeCategory(int index) {
    selectedCategory.value = index;
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on_outlined,
                              color: PalleteColor.primaryPurple,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Jakarta Pusat (GPS Aktif)',
                              style: TextStyle(
                                color: PalleteColor.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cari Kerja di Sekitar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: PalleteColor.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: PalleteColor.lightPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'AI',
                        style: TextStyle(
                          color: PalleteColor.primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(
                  begin: -0.2,
                  end: 0,
                ),

            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    bool isSelected =
                        controller.selectedCategory.value == index;

                    return GestureDetector(
                      onTap: () => controller.changeCategory(index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? PalleteColor.primaryPurple
                              : PalleteColor.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? PalleteColor.primaryPurple
                                : PalleteColor.borderColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            controller.categories[index],
                            style: TextStyle(
                              color: isSelected
                                  ? PalleteColor.white
                                  : PalleteColor.textDark,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ).animate().fade(duration: 400.ms).slideX(
                  begin: 0.1,
                  end: 0,
                ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                itemCount: controller.gigs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  var gig = controller.gigs[index];

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: PalleteColor.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: PalleteColor.borderColor,
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: gig['tagBg'] as Color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                gig['tag'] as String,
                                style: TextStyle(
                                  color: gig['tagColor'] as Color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: gig['price'] as String,
                                    style: const TextStyle(
                                      color:
                                          PalleteColor.primaryPurple,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n${gig['unit']}',
                                    style: const TextStyle(
                                      color: PalleteColor.textGrey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          gig['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: PalleteColor.textDark,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(
                              Icons.send_outlined,
                              size: 12,
                              color: PalleteColor.primaryPurple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${gig['distance']} • ${gig['duration']}',
                              style: const TextStyle(
                                color: PalleteColor.textGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              gig['time'] as String,
                              style: const TextStyle(
                                color: PalleteColor.textGrey,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              'Lihat Detail →',
                              style: TextStyle(
                                color: PalleteColor.primaryPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      .animate(delay: (50 * index).ms)
                      .fade(duration: 400.ms)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}