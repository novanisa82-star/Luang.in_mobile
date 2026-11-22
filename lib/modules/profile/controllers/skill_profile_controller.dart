import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/core/config/api_config.dart';
import 'package:luang_in/utils/app_snackbar.dart';

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
      AppSnackbar.showError(
        e,
        title: 'Gagal Memuat Keahlian',
        defaultMessage: 'Tidak dapat memuat daftar keahlian. Silakan coba kembali.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addSkill() {
    final value = skillController.text.trim();

    if (value.isEmpty) return;

    if (skills.any((item) => item.toLowerCase() == value.toLowerCase())) {
      AppSnackbar.warning(
        'Keahlian Sudah Ada',
        'Keahlian tersebut sudah ada dalam daftar Anda.',
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
      AppSnackbar.warning('Perhatian', 'Silakan pilih bidang pekerjaan utama Anda.');
      return;
    }

    if (skills.isEmpty) {
      AppSnackbar.warning('Perhatian', 'Tambahkan minimal satu keahlian yang Anda kuasai.');
      return;
    }

    if (selectedExperience.value.isEmpty) {
      AppSnackbar.warning('Perhatian', 'Silakan pilih tingkat pengalaman kerja Anda.');
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

      AppSnackbar.success(
        'Berhasil',
        response['message']?.toString() ?? 'Profil keahlian berhasil disimpan.',
      );
    } catch (e) {
      AppSnackbar.showError(
        e,
        title: 'Gagal Menyimpan',
        defaultMessage: 'Gagal menyimpan profil keahlian Anda.',
      );
    } finally {
      isSaving.value = false;
    }
  }
}
