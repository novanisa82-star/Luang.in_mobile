import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/pallete_color.dart';

class HomeController extends GetxController {
  // State Filter
  var selectedCategory = 0.obs;
  var isFilterActive = false.obs;

  // Filter Values
  var selectedMinWage = 0.0.obs;
  var selectedRating = 0.0.obs;
  var selectedType = 'Semua'.obs;

  // Controllers
  final searchController = TextEditingController();
  final jobTitleFilterController = TextEditingController();

  final categories = [
    'Semua (18)',
    'Layanan F&B',
    'Upah Tinggi',
    'Hari Ini',
  ];

  final rawGigs = [
    {
      'tag': 'Mitra Barista',
      'tagColor': const Color(0xFF8833E6),
      'tagBg': const Color(0xFFEFE7FE),
      'price': 'Rp525.000',
      'priceValue': 525000,
      'unit': '/shift',
      'type': 'Shift',
      'rating': 4.8,
      'title': 'Kopi Kenangan Senopati',
      'distance': '1,2 km dari sini',
      'duration': 'Shift 4 Jam',
      'time': 'Mulai Hari Ini, 16:00',
    },
    {
      'tag': 'Tim Acara',
      'tagColor': const Color(0xFFD97706),
      'tagBg': const Color(0xFFFEF3C7),
      'price': 'Rp900.000',
      'priceValue': 900000,
      'unit': '/hari',
      'type': 'Daily',
      'rating': 4.5,
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
      'priceValue': 720000,
      'unit': '/shift',
      'type': 'Shift',
      'rating': 4.2,
      'title': 'Gudang Logistik Paxel',
      'distance': '3,1 km dari sini',
      'duration': 'Shift Malam',
      'time': 'Malam Ini, 21:00',
    },
  ];

  // Logic Filtering Gabungan
  List<Map<String, dynamic>> get filteredGigs {
    String query = searchController.text.toLowerCase();
    String jobFilter = jobTitleFilterController.text.toLowerCase();

    return rawGigs.where((gig) {
      // 1. Search Query Utama
      bool matchesSearch = (gig['title'] as String).toLowerCase().contains(query) ||
          (gig['tag'] as String).toLowerCase().contains(query);

      // 2. Filter Spesifik Pekerjaan dari Modal
      bool matchesJobFilter = jobFilter.isEmpty ||
          (gig['tag'] as String).toLowerCase().contains(jobFilter) ||
          (gig['title'] as String).toLowerCase().contains(jobFilter);

      // 3. Kategori Tab
      bool matchesCategory = true;
      if (selectedCategory.value == 1) {
        matchesCategory = gig['tag'] == 'Mitra Barista';
      } else if (selectedCategory.value == 2) {
        matchesCategory = (gig['priceValue'] as int) >= 700000;
      } else if (selectedCategory.value == 3) {
        matchesCategory = (gig['time'] as String).contains('Hari Ini');
      }

      // 4. Filter Upah, Rating, & Tipe
      bool matchesWage = (gig['priceValue'] as int) >= selectedMinWage.value;
      bool matchesRating = (gig['rating'] as double) >= selectedRating.value;
      bool matchesType = selectedType.value == 'Semua' || gig['type'] == selectedType.value;

      return matchesSearch &&
          matchesJobFilter &&
          matchesCategory &&
          matchesWage &&
          matchesRating &&
          matchesType;
    }).toList();
  }

  void changeCategory(int index) {
    selectedCategory.value = index;
    update();
  }

  void applyFilter({
    required double minWage,
    required double rating,
    required String type,
  }) {
    selectedMinWage.value = minWage;
    selectedRating.value = rating;
    selectedType.value = type;

    isFilterActive.value = minWage > 0 ||
        rating > 0 ||
        type != 'Semua' ||
        jobTitleFilterController.text.isNotEmpty;
    update();
  }

  void resetFilter() {
    selectedMinWage.value = 0.0;
    selectedRating.value = 0.0;
    selectedType.value = 'Semua';
    jobTitleFilterController.clear();
    isFilterActive.value = false;
    update();
  }

  void openFilterBottomSheet(BuildContext context) {
    double tempWage = selectedMinWage.value;
    double tempRating = selectedRating.value;
    String tempType = selectedType.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header & Reset Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Pekerjaan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: PalleteColor.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setStateModal(() {
                              tempWage = 0.0;
                              tempRating = 0.0;
                              tempType = 'Semua';
                            });
                            resetFilter();
                          },
                          child: const Text(
                            'Reset All',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 1. TextFormField Spesifik Pekerjaan
                    const Text(
                      'Spesifikasi Pekerjaan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: PalleteColor.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: jobTitleFilterController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Misal: Barista, Event Crew, Gudang...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                          prefixIcon: Icon(
                            Icons.work_outline_rounded,
                            color: Colors.grey.shade500,
                            size: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Rating Minimum (Di-scroll Horizontal agar TIDAK Overflow)
                    const Text(
                      'Rating Minimal Pemberi Kerja',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: PalleteColor.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [0.0, 3.0, 4.0, 4.5].map((ratingVal) {
                          bool isSelected = tempRating == ratingVal;
                          String label = ratingVal == 0.0 ? 'Semua' : '⭐ $ratingVal+';
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(label),
                              selected: isSelected,
                              selectedColor: PalleteColor.primaryPurple.withOpacity(0.15),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? PalleteColor.primaryPurple
                                    : Colors.grey.shade700,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected
                                      ? PalleteColor.primaryPurple
                                      : Colors.transparent,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setStateModal(() => tempRating = selected ? ratingVal : 0.0);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 3. Tipe Pekerjaan
                    const Text(
                      'Tipe Waktu Kerja',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: PalleteColor.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: ['Semua', 'Shift', 'Daily'].map((type) {
                          bool isSelected = tempType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(type == 'Daily' ? 'Harian' : type),
                              selected: isSelected,
                              selectedColor: PalleteColor.primaryPurple.withOpacity(0.15),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? PalleteColor.primaryPurple
                                    : Colors.grey.shade700,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected
                                      ? PalleteColor.primaryPurple
                                      : Colors.transparent,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setStateModal(() => tempType = selected ? type : 'Semua');
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 4. Upah Minimum Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upah Minimal',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: PalleteColor.textDark,
                          ),
                        ),
                        Text(
                          'Rp ${tempWage.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            color: PalleteColor.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: PalleteColor.primaryPurple,
                        thumbColor: PalleteColor.primaryPurple,
                        overlayColor: PalleteColor.primaryPurple.withOpacity(0.15),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: tempWage,
                        min: 0,
                        max: 1000000,
                        divisions: 10,
                        onChanged: (value) {
                          setStateModal(() => tempWage = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Button Apply
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          applyFilter(
                            minWage: tempWage,
                            rating: tempRating,
                            type: tempType,
                          );
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PalleteColor.primaryPurple,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Terapkan Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    jobTitleFilterController.dispose();
    super.onClose();
  }
}