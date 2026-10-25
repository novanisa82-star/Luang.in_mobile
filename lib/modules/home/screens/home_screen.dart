import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/home_controller.dart';
import 'detail_screen.dart';
import '../../../utils/pallete_color.dart';
import '../controllers/location_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final LocationController locationController = Get.put(
    LocationController(),
    permanent: true,
  );

  final HomeController controller = Get.put(HomeController(), permanent: true);

  Color get purple => PalleteColor.primaryPurple;

  static const Color pageColor = Color(0xFFF8F7FC);
  static const Color borderColor = Color(0xFFECE8F4);
  static const Color mutedColor = Color(0xFF898397);
  static const Color darkColor = Color(0xFF242033);

  String _rupiah(double value) {
    final digits = value.toInt().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }

  String _formatDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Tanggal tidak tersedia';
    }

    final date = DateTime.tryParse(value.toString());

    if (date == null) return 'Tanggal tidak tersedia';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showFilterBottomSheet(BuildContext context) {
    double minWage = controller.selectedMinWage.value.clamp(0.0, 1000000000.0);
    double rating = controller.selectedRating.value;
    String type = controller.selectedType.value;

    final jobTitleController = TextEditingController(
      text: controller.jobTitleFilterController.text,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.42),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.88,
                ),
                decoration: const BoxDecoration(
                  color: pageColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAD5E4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 16, 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Filter pekerjaan',
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Temukan pekerjaan yang sesuai untukmu.',
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                minWage = 0;
                                rating = 0;
                                type = 'Semua';
                                jobTitleController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.restart_alt_rounded,
                              color: purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: borderColor),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                        children: [
                          _filterHeading('Nama pekerjaan'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: jobTitleController,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Contoh: Barista, kasir...',
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: purple,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: purple,
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 26),
                          _filterHeading('Minimal upah'),
                          const SizedBox(height: 8),
                          Text(
                            minWage == 0
                                ? 'Semua upah'
                                : '${_rupiah(minWage)}+',
                            style: TextStyle(
                              color: purple,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Slider(
                            value: minWage,
                            min: 0,
                            max: 1000000000,
                            divisions: 100,
                            activeColor: purple,
                            onChanged: (value) {
                              setModalState(() => minWage = value);
                            },
                          ),
                          const SizedBox(height: 20),
                          _filterHeading('Rating minimum'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 9,
                            children: [0.0, 3.0, 4.0, 5.0].map((value) {
                              return _choiceChip(
                                label: value == 0
                                    ? 'Semua rating'
                                    : '${value.toInt()}+ ★',
                                selected: rating == value,
                                onTap: () {
                                  setModalState(() => rating = value);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 26),
                          _filterHeading('Jenis pekerjaan'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 9,
                            children: ['Semua', 'Daily', 'Shift'].map((value) {
                              return _choiceChip(
                                label: value,
                                selected: type == value,
                                onTap: () {
                                  setModalState(() => type = value);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        22,
                        15,
                        22,
                        MediaQuery.of(context).viewInsets.bottom + 18,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: borderColor)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.resetFilter();
                                Navigator.pop(sheetContext);
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.applyFilter(
                                  minWage: minWage,
                                  rating: rating,
                                  type: type,
                                  jobTitle: jobTitleController.text,
                                );
                                Navigator.pop(sheetContext);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Terapkan filter'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 400), () {
        jobTitleController.dispose();
      });
    });
  }

  Widget _filterHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: darkColor,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _choiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? const Color(0xFFEFE7FE) : Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected ? purple.withOpacity(0.45) : borderColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? purple : const Color(0xFF777184),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
                  child: Row(
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
                                Obx(
                                  () => Text(
                                    locationController.locationName.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: mutedColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Cari Kerja Luang',
                              style: TextStyle(
                                fontSize: 25,
                                height: 1.15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.9,
                                color: darkColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Peluang baru dimulai dari sini.',
                              style: TextStyle(fontSize: 12, color: mutedColor),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          gradient: PalleteColor.gradient,
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: purple.withOpacity(0.2),
                              blurRadius: 15,
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
                .fadeIn(duration: 350.ms)
                .slideY(begin: -0.06, end: 0, duration: 350.ms),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: (_) => controller.update(),
                        decoration: InputDecoration(
                          hintText: 'Cari pekerjaan atau perusahaan...',
                          hintStyle: const TextStyle(
                            color: Color(0xFFA7A1B4),
                            fontSize: 12,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: purple,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() {
                    final active = controller.isFilterActive.value;

                    return Material(
                      color: active ? purple : Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      child: InkWell(
                        onTap: () => _showFilterBottomSheet(context),
                        borderRadius: BorderRadius.circular(17),
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: active ? purple : borderColor,
                            ),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: active ? Colors.white : darkColor,
                            size: 21,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 23),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Kategori pekerjaan',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.swipe_rounded,
                    size: 15,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final selected = controller.selectedCategory.value == index;

                    return Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: Material(
                        color: selected ? purple : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () => controller.changeCategory(index),
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 17,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected ? purple : borderColor,
                              ),
                              gradient: selected ? PalleteColor.gradient : null,
                            ),
                            child: Text(
                              controller.categories[index],
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF777184),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GetBuilder<HomeController>(
                builder: (cnt) {
                  return Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Pekerjaan untukmu',
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE7FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${cnt.filteredGigs.length} lowongan',
                          style: TextStyle(
                            color: purple,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: GetBuilder<HomeController>(
                builder: (cnt) {
                  if (cnt.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: purple),
                    );
                  }

                  if (cnt.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFE7FE),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cloud_off_rounded,
                                color: purple,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum bisa memuat lowongan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: darkColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cnt.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: mutedColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: cnt.fetchPekerjaan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Coba lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final list = cnt.filteredGigs;

                  if (list.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFE7FE),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_off_rounded,
                                size: 34,
                                color: purple,
                              ),
                            ),
                            const SizedBox(height: 17),
                            const Text(
                              'Belum ada pekerjaan yang cocok',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: darkColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Coba kata kunci atau ubah filter pencarianmu.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                controller.searchController.clear();
                                controller.resetFilter();
                                controller.changeCategory(0);
                                controller.update();
                              },
                              child: Text(
                                'Hapus semua filter',
                                style: TextStyle(
                                  color: purple,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: purple,
                    onRefresh: cnt.fetchPekerjaan,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(22, 2, 22, 28),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final gig = list[index];
                        final rating = gig['rating'] as double?;
                        final totalRating = gig['total_rating'] as int? ?? 0;

                        final duration = gig['duration']?.toString() ?? '';
                        final title = gig['title']?.toString() ?? '';
                        final company =
                            gig['nama_pt']?.toString() ?? 'Perusahaan';
                        final price = gig['price']?.toString() ?? 'Rp0';
                        final type = gig['type']?.toString() ?? 'Daily';

                        return Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(23),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(23),
                                onTap: () {
                                  Get.to(
                                    () => const DetailScreen(),
                                    transition: Transition.rightToLeft,
                                    duration: const Duration(milliseconds: 280),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(17),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    border: Border.all(color: borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: purple.withOpacity(0.045),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // NAMA PERUSAHAAN
                                      Row(
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF0E8FF),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Icon(
                                              Icons.business_rounded,
                                              color: purple,
                                              size: 21,
                                            ),
                                          ),
                                          const SizedBox(width: 11),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  company,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: darkColor,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                if (rating != null &&
                                                    rating > 0 &&
                                                    totalRating > 0)
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star_rounded,
                                                        color: Color(
                                                          0xFFFFB547,
                                                        ),
                                                        size: 14,
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                        '${rating.toStringAsFixed(1)} · $totalRating ulasan',
                                                        style: const TextStyle(
                                                          color: mutedColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                else
                                                  const Text(
                                                    'Informasi lowongan',
                                                    style: TextStyle(
                                                      color: mutedColor,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFF0ECF5),
                                      ),
                                      const SizedBox(height: 15),

                                      // JUDUL DAN UPAH
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title,
                                                  style: const TextStyle(
                                                    color: darkColor,
                                                    fontSize: 16,
                                                    height: 1.35,
                                                    fontWeight: FontWeight.w900,
                                                    letterSpacing: -0.25,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFF0E8FF,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      type,
                                                      style: TextStyle(
                                                        color: purple,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  price,
                                                  textAlign: TextAlign.end,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: purple,
                                                    fontSize: 14,
                                                    height: 1.35,
                                                    fontWeight: FontWeight.w900,
                                                    letterSpacing: -0.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  duration.isEmpty
                                                      ? 'Upah pekerjaan'
                                                      : duration,
                                                  textAlign: TextAlign.end,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: mutedColor,
                                                    fontSize: 10,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 17),

                                      // LOKASI
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: purple,
                                            size: 17,
                                          ),
                                          const SizedBox(width: 7),
                                          const Expanded(
                                            child: Text(
                                              'Lokasi pekerjaan belum tersedia',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: mutedColor,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 13),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFF0ECF5),
                                      ),
                                      const SizedBox(height: 13),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            color: mutedColor,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 7),
                                          Expanded(
                                            child: Text(
                                              _formatDate(gig['time']),
                                              style: const TextStyle(
                                                color: mutedColor,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Lihat detail',
                                            style: TextStyle(
                                              color: purple,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: purple,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate(delay: Duration(milliseconds: 45 * index))
                            .fadeIn(duration: 350.ms)
                            .slideY(begin: 0.04, end: 0);
                      },
                    ),
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
