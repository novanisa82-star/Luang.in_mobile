import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luang_in/core/config/api_config.dart';
import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/core/services/saved_jobs_service.dart';
import 'package:luang_in/core/services/storage_service.dart';
import 'package:luang_in/data/models/home_model.dart';
import 'package:luang_in/modules/home/controllers/location_controller.dart';
import 'package:luang_in/modules/riwayat/controllers/riwayat_controller.dart';
import 'package:luang_in/utils/app_snackbar.dart';
import 'package:luang_in/utils/document_helper.dart';
import 'package:luang_in/utils/pallete_color.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailController extends GetxController {
  final int? initialJobId;
  final HomeModel? initialJob;
  final double? initialRating;

  DetailController({
    this.initialJobId,
    this.initialJob,
    this.initialRating,
  });

  final RxBool isSaved = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isApplying = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<HomeModel> job = Rxn<HomeModel>();
  final RxString locationAddress = 'Memuat wilayah...'.obs;
  final RxString distanceText = ''.obs;

  // Form Data Pribadi & Upload CV untuk Melamar
  final namaController = TextEditingController();
  final whatsappController = TextEditingController();
  final domisiliController = TextEditingController();
  final catatanController = TextEditingController();

  final RxnString selectedCvPath = RxnString();
  final RxnString selectedCvName = RxnString();
  final RxnInt selectedCvSize = RxnInt();

  int? get effectiveJobId => initialJobId ?? initialJob?.id;

  double? get effectiveRating => job.value?.rating ?? initialRating;

  @override
  void onInit() {
    super.onInit();
    job.value = initialJob;
    prefillUserData();
    _syncSavedState();
    resolveLocationName();
    if (effectiveJobId != null && effectiveJobId! > 0) {
      fetchJobDetail();
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    whatsappController.dispose();
    domisiliController.dispose();
    catatanController.dispose();
    super.onClose();
  }

  void prefillUserData() {
    try {
      if (Get.isRegistered<StorageService>()) {
        final user = Get.find<StorageService>().getUser();
        if (user != null) {
          if (namaController.text.isEmpty) {
            namaController.text = user['name']?.toString() ?? '';
          }
          if (whatsappController.text.isEmpty) {
            whatsappController.text = user['whatsapp']?.toString() ?? '';
          }
          if (domisiliController.text.isEmpty) {
            domisiliController.text = user['domisili']?.toString() ?? '';
          }
        }
      }
    } catch (_) {}
  }

  Future<void> fetchJobDetail() async {
    final id = effectiveJobId;
    if (id == null || id <= 0) return;

    isLoading.value = job.value == null;
    errorMessage.value = null;

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.getAuthenticated(
        ApiConfig.pekerjaanDetail(id),
      );

      final data = response['data'];
      if (data is Map<String, dynamic>) {
        job.value = HomeModel.fromJson(data);
        _syncSavedState();
        resolveLocationName();
      }
    } catch (e) {
      if (job.value == null) {
        errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _syncSavedState() {
    final currentJob = job.value;
    if (currentJob == null) return;
    if (Get.isRegistered<SavedJobsService>()) {
      isSaved.value = Get.find<SavedJobsService>().isSaved(currentJob.id);
    }
  }

  Future<void> resolveLocationName() async {
    final currentJob = job.value;
    if (currentJob == null) return;

    final lat = currentJob.latitude;
    final lng = currentJob.longitude;

    if (lat == 0 && lng == 0) {
      locationAddress.value = 'Wilayah pekerjaan belum ditentukan';
      distanceText.value = '';
      return;
    }

    if (Get.isRegistered<LocationController>()) {
      final pos = Get.find<LocationController>().currentPosition.value;
      if (pos != null) {
        final meters = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          lat,
          lng,
        );
        final km = meters / 1000.0;
        distanceText.value = '${km.toStringAsFixed(1)} km dari lokasi Anda';
      }
    }

    try {
      final places = await placemarkFromCoordinates(lat, lng);
      if (places.isNotEmpty) {
        final p = places.first;
        final parts = <String>[
          if (p.subLocality != null && p.subLocality!.isNotEmpty)
            'Kel./Desa ${p.subLocality!}',
          if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
          if (p.subAdministrativeArea != null &&
              p.subAdministrativeArea!.isNotEmpty)
            p.subAdministrativeArea!,
          if (p.administrativeArea != null &&
              p.administrativeArea!.isNotEmpty)
            p.administrativeArea!,
        ];
        if (parts.isNotEmpty) {
          locationAddress.value = parts.join(', ');
          return;
        }
      }
      locationAddress.value = 'Sekitar Lokasi Perusahaan';
    } catch (_) {
      locationAddress.value = 'Sekitar Lokasi Perusahaan';
    }
  }

  Future<void> toggleSave(BuildContext context) async {
    final currentJob = job.value;
    if (currentJob == null) return;

    if (Get.isRegistered<SavedJobsService>()) {
      final saved = await Get.find<SavedJobsService>().toggleSave(currentJob);
      isSaved.value = saved;
    } else {
      isSaved.value = !isSaved.value;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSaved.value
                ? 'Lowongan berhasil disimpan ke daftar favorit'
                : 'Lowongan dihapus dari simpanan',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> pickCvFile() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (files.isNotEmpty) {
        final file = files.first;
        if (file.path != null) {
          final size = file.lengthSync() ?? await file.length();
          selectedCvPath.value = file.path;
          selectedCvName.value = file.name;
          selectedCvSize.value = size;
        }
      }
    } catch (e) {
      AppSnackbar.error(
        'Gagal Memilih CV',
        'Terjadi kendala saat memilih berkas CV: $e',
      );
    }
  }

  void clearSelectedCv() {
    selectedCvPath.value = null;
    selectedCvName.value = null;
    selectedCvSize.value = null;
  }

  Future<void> submitApplication(BuildContext context) async {
    final currentJob = job.value;
    if (currentJob == null || isApplying.value || currentJob.sudahMelamar) {
      return;
    }

    final nama = namaController.text.trim();
    final whatsapp = whatsappController.text.trim();
    final domisili = domisiliController.text.trim();
    final catatan = catatanController.text.trim();
    final cvPath = selectedCvPath.value;

    if (nama.isEmpty) {
      AppSnackbar.warning('Data Belum Lengkap', 'Nama lengkap wajib diisi.');
      return;
    }

    if (whatsapp.isEmpty) {
      AppSnackbar.warning(
        'Data Belum Lengkap',
        'Nomor WhatsApp aktif wajib diisi agar PT dapat menghubungi Anda.',
      );
      return;
    }

    if (cvPath == null || cvPath.isEmpty) {
      AppSnackbar.warning(
        'CV Belum Diunggah',
        'Silakan unggah berkas CV Anda (PDF/DOC/DOCX) terlebih dahulu.',
      );
      return;
    }

    isApplying.value = true;

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.postMultipartAuthenticated(
        ApiConfig.lamarPekerjaan(currentJob.id),
        fields: {
          'nama': nama,
          'whatsapp': whatsapp,
          'domisili': domisili,
          'catatan': catatan,
        },
        filePath: cvPath,
        fileFieldName: 'cv',
      );

      // Tutup bottom sheet form terlebih dahulu
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      clearSelectedCv();
      catatanController.clear();

      await fetchJobDetail();

      if (Get.isRegistered<RiwayatController>()) {
        Get.find<RiwayatController>().muatUlang();
      }

      // Gunakan Get.dialog agar tidak bergantung pada sheetContext yang sudah ditutup
      _showSuccessDialog(
        response['message']?.toString() ??
            'Lamaran dan CV Anda berhasil dikirim! Menunggu konfirmasi perusahaan.',
      );
    } catch (e) {
      AppSnackbar.showError(
        e,
        title: 'Gagal Mengirim Lamaran',
        defaultMessage: 'Tidak dapat mengirim lamaran. Silakan coba lagi.',
      );
    } finally {
      isApplying.value = false;
    }
  }

  void _showSuccessDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Lottie.asset(
                  'assets/lottie/success.json',
                  repeat: false,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lamaran Terkirim!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: PalleteColor.textGrey,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalleteColor.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Oke, Mengerti',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  String formatCvSize(int? bytes) {
    if (bytes == null) return '';
    return DocumentHelper.formatFileSize(bytes);
  }

  String formatRupiah(String rawUpah) {
    final digits = rawUpah.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 'Rp0';
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

  String formatDate(DateTime? dt) {
    if (dt == null) return '-';
    final local = dt.toLocal();
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
    final day = local.day.toString().padLeft(2, '0');
    final month = months[local.month - 1];
    return '$day $month ${local.year}';
  }

  String formatDateTime(DateTime? dt) {
    if (dt == null) return 'Tidak dibatasi';
    final local = dt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${formatDate(local)}, $hour:$minute WIB';
  }

  Future<void> openGoogleMaps({bool directions = false}) async {
    final currentJob = job.value;
    if (currentJob == null) return;

    final lat = currentJob.latitude;
    final lng = currentJob.longitude;

    final Uri url = directions
        ? Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng')
        : Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        AppSnackbar.warning(
          'Gagal Membuka Peta',
          'Tidak dapat membuka Google Maps di perangkat ini.',
        );
      }
    } catch (e) {
      AppSnackbar.showError(
        e,
        title: 'Gagal Membuka Google Maps',
        defaultMessage: 'Pastikan aplikasi Google Maps atau browser terpasang.',
      );
    }
  }

  Future<void> openWhatsappPt() async {
    final currentJob = job.value;
    if (currentJob == null) return;

    final rawPhone = currentJob.whatsappPt;
    if (rawPhone == null || rawPhone.isEmpty) {
      AppSnackbar.warning(
        'Nomor WhatsApp Tidak Tersedia',
        'Perusahaan belum mencantumkan nomor WhatsApp aktif.',
      );
      return;
    }

    String clean = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('0')) {
      clean = '62${clean.substring(1)}';
    }

    final text = Uri.encodeComponent(
      'Halo ${currentJob.namaPt}, saya pelamar yang diterima untuk posisi "${currentJob.judul}" di Luang.In. Mohon arahan selanjutnya.',
    );
    final url = Uri.parse('https://wa.me/$clean?text=$text');

    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        AppSnackbar.warning(
          'Gagal Membuka WhatsApp',
          'Pastikan aplikasi WhatsApp terpasang di perangkat Anda.',
        );
      }
    } catch (e) {
      AppSnackbar.showError(
        e,
        title: 'Gagal Membuka WhatsApp',
        defaultMessage: 'Tidak dapat membuka WhatsApp.',
      );
    }
  }

  String moderasiLabel(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return 'Disetujui Moderasi';
      case 'ditolak':
        return 'Ditolak Moderasi';
      default:
        return 'Menunggu Moderasi';
    }
  }

  String lokerLabel(String status) {
    return status.toLowerCase() == 'aktif' ? 'Loker Aktif' : 'Loker Ditutup';
  }

  String statusLamaranLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'diterima':
        return 'Lamaran Diterima';
      case 'ditolak':
        return 'Lamaran Ditolak';
      default:
        return 'Menunggu Konfirmasi';
    }
  }
}
