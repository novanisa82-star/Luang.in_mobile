import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/data/models/user_model.dart';
import 'package:luang_in/core/config/api_config.dart';

class ProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final ImagePicker imagePicker = ImagePicker();

  final user = Rxn<UserModel>();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userWhatsapp = ''.obs;
  final userDomisili = ''.obs;
  final fotoProfil = ''.obs;

  final isLoading = false.obs;
  final isUploadingPhoto = false.obs;
  final isSaving = false.obs;
  final isChangingPassword = false.obs;

  final pushNotifications = true.obs;

  final nameController = TextEditingController();
  final whatsappController = TextEditingController();
  final domisiliController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    whatsappController.dispose();
    domisiliController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final response = await apiService.getAuthenticated(
        '${ApiConfig.baseUrl}/mobile/me',
      );
      final data = response['user'];

      if (data is Map<String, dynamic>) {
        _setUser(UserModel.fromJson(data));
      }
    } catch (e) {
      Get.snackbar(
        'Gagal memuat profil',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _setUser(UserModel data) {
    user.value = data;
    userName.value = data.name;
    userEmail.value = data.email;
    userWhatsapp.value = data.whatsapp ?? '';
    userDomisili.value = data.domisili ?? '';
    fotoProfil.value = data.fotoProfil ?? '';

    nameController.text = data.name;
    whatsappController.text = data.whatsapp ?? '';
    domisiliController.text = data.domisili ?? '';
  }

  String get initials {
    final name = userName.value.trim();

    if (name.isEmpty) return 'U';

    final parts = name.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String? get photoUrl {
    final path = fotoProfil.value.trim();

    if (path.isEmpty) return null;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final baseUrl = ApiConfig.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');

    return '$baseUrl/storage/${path.replaceFirst(RegExp(r'^/'), '')}';
  }

  Future<void> pickPhoto(ImageSource source) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile == null) return;

      isUploadingPhoto.value = true;

      final response = await apiService.uploadFile(
        '${ApiConfig.baseUrl}/mobile/profile/photo',
        filePath: pickedFile.path,
        fieldName: 'foto_profil',
      );

      final data = response['user'];

      if (data is Map<String, dynamic>) {
        _setUser(UserModel.fromJson(data));
      } else {
        await loadProfile();
      }

      Get.snackbar(
        'Berhasil',
        'Foto profil berhasil diperbarui.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal mengunggah foto',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  void showPhotoOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E1E9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ubah foto profil',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF29243A),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFF8833E6),
              ),
              title: const Text('Ambil dari kamera'),
              onTap: () {
                Get.back();
                pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Color(0xFF8833E6),
              ),
              title: const Text('Pilih dari galeri'),
              onTap: () {
                Get.back();
                pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Nama tidak boleh kosong.');
      return;
    }

    try {
      isSaving.value = true;

      final response = await apiService.putAuthenticated(
        '${ApiConfig.baseUrl}/mobile/profile',
        data: {
          'name': nameController.text.trim(),
          'whatsapp': whatsappController.text.trim(),
          'domisili': domisiliController.text.trim(),
        },
      );

      final data = response['user'];

      if (data is Map<String, dynamic>) {
        _setUser(UserModel.fromJson(data));
      } else {
        await loadProfile();
      }

      Get.snackbar(
        'Berhasil',
        response['message']?.toString() ??
            'Informasi pribadi berhasil diperbarui.',
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

  Future<void> changePassword() async {
    final current = currentPasswordController.text;
    final password = newPasswordController.text;
    final confirmation = confirmPasswordController.text;

    if (current.isEmpty || password.isEmpty || confirmation.isEmpty) {
      Get.snackbar('Perhatian', 'Semua kolom password wajib diisi.');
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Perhatian', 'Password baru minimal 8 karakter.');
      return;
    }

    if (password != confirmation) {
      Get.snackbar('Perhatian', 'Konfirmasi password tidak sama.');
      return;
    }

    try {
      isChangingPassword.value = true;

      final response = await apiService.putAuthenticated(
        '${ApiConfig.baseUrl}/mobile/change-password',
        data: {
          'current_password': current,
          'password': password,
          'password_confirmation': confirmation,
        },
      );

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.snackbar(
        'Berhasil',
        response['message']?.toString() ?? 'Password berhasil diperbarui.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal mengganti password',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  void toggleNotifications(bool value) {
    pushNotifications.value = value;
  }
}
