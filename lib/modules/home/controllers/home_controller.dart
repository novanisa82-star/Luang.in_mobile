import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/core/config/api_config.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/home_model.dart';
import '../../../utils/pallete_color.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final RxList<HomeModel> pekerjaanList = <HomeModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedCategory = 0.obs;
  final isFilterActive = false.obs;

  final selectedMinWage = 0.0.obs;
  final selectedRating = 0.0.obs;
  final selectedType = 'Semua'.obs;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController jobTitleFilterController =
      TextEditingController();

  final categories = [
    'Semua',
    'Layanan F&B',
    'Upah Tinggi',
    'Hari Ini',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchPekerjaan();
  }

  Future<void> fetchPekerjaan() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      update();

      final response = await apiService.getAuthenticated(
        '${ApiConfig.baseUrl}/mobile/pekerjaan',
      );

      final data = response['data'];

      if (data is! List) {
        throw Exception('Format data lowongan tidak valid.');
      }

      pekerjaanList.assignAll(
        data.whereType<Map<String, dynamic>>().map(HomeModel.fromJson),
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  List<Map<String, dynamic>> get rawGigs {
    return pekerjaanList.map((p) {
      final upahAngka =
          int.tryParse(p.upah.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      return {
        'id': p.id,
        'user_id': p.userId,
        'nama_pt': p.namaPt,
        'tag': p.durasi,
        'tagColor': PalleteColor.primaryPurple,
        'tagBg': const Color(0xFFEFE7FE),
        'price': _formatRupiah(upahAngka),
        'priceValue': upahAngka,
        'unit': p.durasi,
        'type': p.durasi.toLowerCase().contains('shift')
            ? 'Shift'
            : 'Daily',
        'rating': p.rating,
        'total_rating': p.totalRating,
        'title': p.judul,
        'distance': '',
        'duration': p.durasi,
        'time': p.createdAt?.toLocal().toString() ?? '',
        'deskripsi': p.deskripsi,
        'latitude': p.latitude,
        'longitude': p.longitude,
      };
    }).toList();
  }

  String _formatRupiah(int value) {
    final digits = value.toString();
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

  List<Map<String, dynamic>> get filteredGigs {
    final query = searchController.text.toLowerCase().trim();
    final jobFilter = jobTitleFilterController.text.toLowerCase().trim();

    return rawGigs.where((gig) {
      final title = gig['title'].toString().toLowerCase();
      final company = gig['nama_pt'].toString().toLowerCase();
      final price = gig['priceValue'] as int;
      final rating = gig['rating'] as double?;
      final type = gig['type'].toString();
      final time = gig['time'].toString();

      final matchesSearch =
          title.contains(query) || company.contains(query);

      final matchesJobFilter =
          jobFilter.isEmpty ||
          title.contains(jobFilter) ||
          company.contains(jobFilter);

      bool matchesCategory = true;

      if (selectedCategory.value == 1) {
        matchesCategory = RegExp(
          r'barista|kasir|restoran|kopi|makanan|minuman|f&b',
        ).hasMatch('$title $company');
      } else if (selectedCategory.value == 2) {
        matchesCategory = price >= 700000;
      } else if (selectedCategory.value == 3) {
        final today = DateTime.now().toLocal().toString().substring(0, 10);
        matchesCategory = time.startsWith(today);
      }

      final matchesWage = price >= selectedMinWage.value;

      final matchesRating =
          selectedRating.value == 0 ||
          (rating != null && rating >= selectedRating.value);

      final matchesType =
          selectedType.value == 'Semua' || type == selectedType.value;

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
    String jobTitle = '',
  }) {
    selectedMinWage.value = minWage;
    selectedRating.value = rating;
    selectedType.value = type;
    jobTitleFilterController.text = jobTitle;

    isFilterActive.value =
        minWage > 0 ||
        rating > 0 ||
        type != 'Semua' ||
        jobTitle.trim().isNotEmpty;

    update();
  }

  void resetFilter() {
    selectedMinWage.value = 0;
    selectedRating.value = 0;
    selectedType.value = 'Semua';

    jobTitleFilterController.clear();
    isFilterActive.value = false;

    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    jobTitleFilterController.dispose();
    super.onClose();
  }
}