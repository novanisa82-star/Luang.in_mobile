import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/home_controller.dart';
import 'detail_screen.dart';
import '../../../utils/pallete_color.dart';

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
            // Top Bar Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.near_me_rounded,
                            color: PalleteColor.primaryPurple,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Jakarta Pusat',
                            style: TextStyle(
                              color: PalleteColor.textGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cari Kerja Luang',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: PalleteColor.textDark,
                        ),
                      ),
                    ],
                  ),
                  // Logo Container Presisi
                  Container(
                    width: 46,
                    height: 46,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PalleteColor.primaryPurple.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: PalleteColor.primaryPurple.withOpacity(0.2),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 300.ms).slideY(begin: -0.1, end: 0),

            // Search Bar & Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: controller.searchController,
                        onChanged: (_) => controller.update(),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Cari barista, event crew, dll...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => InkWell(
                      onTap: () => controller.openFilterBottomSheet(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: controller.isFilterActive.value
                              ? PalleteColor.primaryPurple
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: controller.isFilterActive.value
                                  ? Colors.white
                                  : PalleteColor.textDark,
                              size: 20,
                            ),
                            if (controller.isFilterActive.value)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 350.ms).slideY(begin: -0.1, end: 0),

            const SizedBox(height: 8),

            // Horizontal Category List
            SizedBox(
              height: 38,
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? PalleteColor.primaryPurple
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            controller.categories[index],
                            style: TextStyle(
                              color: isSelected
                                  ? PalleteColor.white
                                  : Colors.grey.shade700,
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
            ).animate().fade(duration: 400.ms),

            const SizedBox(height: 12),

            // Gigs List dengan Penambahan Badge Rating di Tiap Card
            Expanded(
              child: GetBuilder<HomeController>(
                builder: (cnt) {
                  final list = cnt.filteredGigs;

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pekerjaan tidak ditemukan',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                    itemCount: list.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      var gig = list[index];

                      return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => const DetailScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: PalleteColor.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
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
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: gig['tagBg'] as Color,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              gig['tag'] as String,
                                              style: TextStyle(
                                                color: gig['tagColor'] as Color,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Rating Badge
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                size: 14,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                '${gig['rating']}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        textAlign: TextAlign.right,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: gig['price'] as String,
                                              style: const TextStyle(
                                                color:
                                                    PalleteColor.primaryPurple,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ${gig['unit']}',
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    gig['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: PalleteColor.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 13,
                                        color: Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${gig['distance']}  •  ${gig['duration']}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFF1F5F9),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            gig['time'] as String,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            'Lihat Detail',
                                            style: TextStyle(
                                              color: PalleteColor.primaryPurple,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 16,
                                            color: PalleteColor.primaryPurple,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate(delay: (40 * index).ms)
                          .fade(duration: 350.ms)
                          .slideY(begin: 0.08, end: 0);
                    },
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
