import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/core/config/api_config.dart';
import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/data/models/home_model.dart';
import 'package:luang_in/modules/riwayat/controllers/riwayat_controller.dart';
import 'package:luang_in/utils/app_snackbar.dart';
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

  int? get effectiveJobId => initialJobId ?? initialJob?.id;

  double? get effectiveRating => job.value?.rating ?? initialRating;

  @override
  void onInit() {
    super.onInit();
    job.value = initialJob;
    if (effectiveJobId != null && effectiveJobId! > 0) {
      fetchJobDetail();
    }
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
      }
    } catch (e) {
      if (job.value == null) {
        errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSave(BuildContext context) {
    isSaved.value = !isSaved.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved.value
              ? 'Lowongan berhasil disimpan'
              : 'Lowongan dihapus dari simpanan',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> confirmAndApply(BuildContext context) async {
    final currentJob = job.value;
    if (currentJob == null || isApplying.value || currentJob.sudahMelamar) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Kirim Lamaran?',
          style: TextStyle(
            color: PalleteColor.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin melamar posisi "${currentJob.judul}" di ${currentJob.namaPt}?',
          style: const TextStyle(
            color: PalleteColor.textGrey,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Batal',
              style: TextStyle(color: PalleteColor.textGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PalleteColor.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Ya, Lamar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isApplying.value = true;

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.postAuthenticated(
        ApiConfig.lamarPekerjaan(currentJob.id),
        data: {},
      );

      AppSnackbar.success(
        'Lamaran Terkirim',
        response['message']?.toString() ??
            'Lamaran berhasil dikirim! Menunggu konfirmasi perusahaan.',
      );

      await fetchJobDetail();

      if (Get.isRegistered<RiwayatController>()) {
        Get.find<RiwayatController>().muatUlang();
      }
    } catch (e) {
      AppSnackbar.showError(
        e,
        title: 'Gagal Melamar',
        defaultMessage: 'Tidak dapat mengirim lamaran. Silakan coba lagi.',
      );
    } finally {
      isApplying.value = false;
    }
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
