import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/core/config/api_config.dart';

class SkillProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final primaryRoleController = TextEditingController();
  final skillController = TextEditingController();

  final selectedRole = ''.obs;
  final selectedExperience = ''.obs;
  final skills = <String>[].obs;

  final isLoading = false.obs;
  final isSaving = false.obs;

  final roles = [
    'UI/UX Designer',
    'Graphic Designer',
    'Web Developer',
    'Mobile Developer',
    'Backend Developer',
    'Frontend Developer',
    'Data Analyst',
    'Digital Marketing',
    'Content Writer',
    'Customer Service',
    'Admin',
    'Barista',
    'Kasir',
    'Lainnya',
  ];

  final experiences = [
    'Non Pengalaman',
    '< 1 Tahun',
    '1 - 2 Tahun',
    '2 - 4 Tahun',
    '> 4 Tahun',
  ];

  @override
  void onInit() {
    super.onInit();
    loadSkillProfile();
  }

  @override
  void onClose() {
    primaryRoleController.dispose();
    skillController.dispose();
    super.onClose();
  }

  Future<void> loadSkillProfile() async {
    try {
      isLoading.value = true;

      final response = await apiService.getAuthenticated(
        '${ApiConfig.baseUrl}/mobile/skill-profile',
      );

      final profile = response['profile'];

      if (profile != null && profile is Map) {
        selectedRole.value = profile['primary_role']?.toString() ?? '';
        primaryRoleController.text = selectedRole.value;

        selectedExperience.value = profile['experience']?.toString() ?? '';

        final savedSkills = profile['skills'];

        if (savedSkills is List) {
          skills.assignAll(savedSkills.map((item) => item.toString()));
        }
      }
    } catch (e) {
      Get.snackbar(
        'Gagal memuat keahlian',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addSkill() {
    final value = skillController.text.trim();

    if (value.isEmpty) return;

    if (skills.any((item) => item.toLowerCase() == value.toLowerCase())) {
      Get.snackbar(
        'Informasi',
        'Keahlian tersebut sudah ditambahkan.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    skills.add(value);
    skillController.clear();
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  Future<void> saveSkillProfile() async {
    if (selectedRole.value.isEmpty) {
      Get.snackbar('Perhatian', 'Pilih bidang pekerjaan terlebih dahulu.');
      return;
    }

    if (skills.isEmpty) {
      Get.snackbar('Perhatian', 'Tambahkan minimal satu keahlian.');
      return;
    }

    if (selectedExperience.value.isEmpty) {
      Get.snackbar('Perhatian', 'Pilih pengalaman kerja terlebih dahulu.');
      return;
    }

    try {
      isSaving.value = true;

      final userResponse = await apiService.getAuthenticated(
        '${ApiConfig.baseUrl}/mobile/me',
      );

      final user = userResponse['user'];

      if (user is! Map) {
        throw Exception('Data pengguna tidak ditemukan.');
      }

      final response = await apiService.postAuthenticated(
        '${ApiConfig.baseUrl}/mobile/skill-profile',
        data: {
          'whatsapp': user['whatsapp']?.toString() ?? '',
          'domisili': user['domisili']?.toString() ?? '',
          'primary_role': selectedRole.value,
          'skills': skills.toList(),
          'experience': selectedExperience.value,
        },
      );

      Get.snackbar(
        'Berhasil',
        response['message']?.toString() ?? 'Profil keahlian berhasil disimpan.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal menyimpan',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
