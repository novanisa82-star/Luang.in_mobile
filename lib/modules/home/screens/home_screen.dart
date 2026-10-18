import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/home_controller.dart';
import 'detail_screen.dart';
import '../../../utils/pallete_color.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  Color get purple => PalleteColor.primaryPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.near_me_rounded,
                                  color: purple,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Jakarta Pusat',
                                  style: TextStyle(
                                    color: PalleteColor.textGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Cari Kerja Luang',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                                color: PalleteColor.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Temukan peluang yang cocok untukmu.',
                              style: TextStyle(
                                fontSize: 11,
                                color: PalleteColor.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          gradient: PalleteColor.gradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: purple.withOpacity(0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 450.ms)
                .slideY(
                  begin: -0.12,
                  end: 0,
                  duration: 450.ms,
                  curve: Curves.easeOutCubic,
                ),

            Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: const Color(0xFFECE8F4)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.025),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: controller.searchController,
                            onChanged: (_) => controller.update(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: PalleteColor.textDark,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari barista, event crew, dll...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: purple,
                                size: 22,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Obx(
                        () => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                controller.openFilterBottomSheet(context),
                            borderRadius: BorderRadius.circular(17),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: controller.isFilterActive.value
                                    ? purple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                  color: controller.isFilterActive.value
                                      ? purple
                                      : const Color(0xFFECE8F4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.025),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.tune_rounded,
                                      key: ValueKey(
                                        controller.isFilterActive.value,
                                      ),
                                      color: controller.isFilterActive.value
                                          ? Colors.white
                                          : PalleteColor.textDark,
                                      size: 21,
                                    ),
                                  ),
                                  if (controller.isFilterActive.value)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        width: 7,
                                        height: 7,
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
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.08, end: 0, duration: 400.ms),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori pekerjaan',
                    style: TextStyle(
                      color: PalleteColor.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Pilih kategori',
                    style: TextStyle(
                      color: purple,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms),

            const SizedBox(height: 12),

            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == index;

                    return GestureDetector(
                      onTap: () => controller.changeCategory(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(right: 9),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 19,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected ? PalleteColor.gradient : null,
                          color: isSelected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFFECE8F4),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: purple.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            controller.categories[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05, end: 0),

            const SizedBox(height: 22),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GetBuilder<HomeController>(
                builder: (cnt) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pekerjaan tersedia',
                        style: TextStyle(
                          color: PalleteColor.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: PalleteColor.lightPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${cnt.filteredGigs.length} pekerjaan',
                          style: TextStyle(
                            color: purple,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 12),

            Expanded(
              child: GetBuilder<HomeController>(
                builder: (cnt) {
                  final list = cnt.filteredGigs;

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.035),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.search_off_rounded,
                              size: 42,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Pekerjaan tidak ditemukan',
                            style: TextStyle(
                              color: PalleteColor.textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Coba kata kunci atau kategori lainnya.',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms);
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 3, 24, 110),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final gig = list[index];

                      return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => const DetailScreen(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              borderRadius: BorderRadius.circular(23),
                              child: Container(
                                padding: const EdgeInsets.all(17),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(23),
                                  border: Border.all(
                                    color: const Color(0xFFEFEAF6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: purple.withOpacity(0.045),
                                      blurRadius: 20,
                                      offset: const Offset(0, 7),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: 9,
                                            runSpacing: 6,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: gig['tagBg'] as Color,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  gig['tag'] as String,
                                                  style: TextStyle(
                                                    color:
                                                        gig['tagColor']
                                                            as Color,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 16,
                                                    color: Color(0xFFFFB800),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    '${gig['rating']}',
                                                    style: const TextStyle(
                                                      color:
                                                          PalleteColor.textDark,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              gig['price'] as String,
                                              style: TextStyle(
                                                color: purple,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              '${gig['unit']}',
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 15),

                                    Text(
                                      gig['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.3,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                        color: PalleteColor.textDark,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          size: 15,
                                          color: purple.withOpacity(0.8),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            '${gig['distance']}  •  ${gig['duration']}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 17),

                                    Container(
                                      height: 1,
                                      color: const Color(0xFFF1EDF7),
                                    ),

                                    const SizedBox(height: 13),

                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: PalleteColor.lightPurple,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.access_time_rounded,
                                            size: 16,
                                            color: purple,
                                          ),
                                        ),
                                        const SizedBox(width: 9),
                                        Expanded(
                                          child: Text(
                                            gig['time'] as String,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Lihat Detail',
                                          style: TextStyle(
                                            color: purple,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 15,
                                          color: purple,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .animate(delay: Duration(milliseconds: 50 * index))
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            duration: 400.ms,
                            curve: Curves.easeOutCubic,
                          );
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
