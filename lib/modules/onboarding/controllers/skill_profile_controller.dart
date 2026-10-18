import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';

class SkillProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final StorageService storageService = Get.find<StorageService>();

  final contactController = TextEditingController();
  final roleController = TextEditingController();
  final skillController = TextEditingController();

  final skills = <String>[].obs;
  final experience = 'Non Pengalaman'.obs;
  final isLoading = false.obs;

  final experienceOptions = <String>[
    'Non Pengalaman',
    '< 1 Tahun',
    '1 - 2 Tahun',
    '2 - 4 Tahun',
    '> 4 Tahun',
  ];

  late Map<String, dynamic> registrationData;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      registrationData = Map<String, dynamic>.from(args);
    } else {
      registrationData = {};
    }

    // Isi data profil lama jika pengguna memang sudah login.
    final user = storageService.getUser();

    if (user != null && storageService.isLoggedIn) {
      contactController.text = user['whatsapp']?.toString() ?? '';
      roleController.text = user['primary_role']?.toString() ?? '';

      final savedSkills = user['skills'];
      if (savedSkills is List) {
        skills.assignAll(savedSkills.map((e) => e.toString()));
      }

      final savedExperience = user['experience']?.toString();
      if (savedExperience != null &&
          experienceOptions.contains(savedExperience)) {
        experience.value = savedExperience;
      }
    }
  }

  void addSkill() {
    final skill = skillController.text.trim();

    if (skill.isEmpty) return;

    if (skills.any((item) => item.toLowerCase() == skill.toLowerCase())) {
      _showMessage('Keahlian tersebut sudah ditambahkan.');
      return;
    }

    skills.add(skill);
    skillController.clear();
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  void updateExperience(String? value) {
    if (value != null && experienceOptions.contains(value)) {
      experience.value = value;
    }
  }

  Future<void> saveProfile() async {
    final whatsapp = contactController.text.trim();
    final role = roleController.text.trim();

    if (registrationData['name'] == null ||
        registrationData['email'] == null ||
        registrationData['password'] == null ||
        registrationData['password_confirmation'] == null) {
      _showMessage('Data registrasi tidak ditemukan. Silakan daftar kembali.');
      return;
    }

    if (whatsapp.isEmpty || role.isEmpty || skills.isEmpty) {
      _showMessage(
        'WhatsApp, pekerjaan utama, dan minimal satu keahlian wajib diisi.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await apiService.post(ApiConfig.completeRegistration, {
        'name': registrationData['name'],
        'email': registrationData['email'],
        'password': registrationData['password'],
        'password_confirmation': registrationData['password_confirmation'],
        'whatsapp': whatsapp,
        'primary_role': role,
        'skills': skills.toList(),
        'experience': experience.value,
      });

      final token = response['token']?.toString();
      final user = response['user'];

      if (token == null || token.isEmpty || user is! Map) {
        _showMessage('Registrasi belum berhasil. Silakan coba kembali.');
        return;
      }

      await storageService.saveToken(token);
      await storageService.saveUser(Map<String, dynamic>.from(user));

      Get.offAllNamed('/main');
    } catch (_) {
      _showMessage('Profil gagal disimpan. Periksa data dan coba kembali.');
    } finally {
      isLoading.value = false;
    }
  }

  void _showMessage(String message) {
    Get.snackbar('Informasi', message, snackPosition: SnackPosition.TOP);
  }

  @override
  void onClose() {
    contactController.dispose();
    roleController.dispose();
    skillController.dispose();
    super.onClose();
  }
}
