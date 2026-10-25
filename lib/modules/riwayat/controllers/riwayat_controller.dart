
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/riwayat_model.dart';
import '../services/riwayat_service.dart';

class RiwayatController extends GetxController {
  final RiwayatService _service = Get.find<RiwayatService>();

  final RxInt selectedTab = 0.obs;
  final RxList<RiwayatModel> lamaran = <RiwayatModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ambilRiwayat();
  }

  Future<void> ambilRiwayat() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final hasil = await _service.getRiwayatLamaran();
      lamaran.assignAll(hasil);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> muatUlang() => ambilRiwayat();

  int get jumlahSemua => lamaran.length;

  int get jumlahAktif =>
      lamaran.where((item) => item.isAktif).length;

  int get jumlahSelesai =>
      lamaran.where((item) => item.isSelesai).length;

  List<RiwayatModel> get lamaranTerfilter {
    switch (selectedTab.value) {
      case 1:
        return lamaran.where((item) => item.isAktif).toList();
      case 2:
        return lamaran.where((item) => item.isSelesai).toList();
      default:
        return lamaran.toList();
    }
  }

  void pilihTab(int index) {
    selectedTab.value = index;
  }

  String formatUpah(int? upah) {
    if (upah == null) return 'Upah tidak tersedia';

    final angka = upah.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      buffer.write(angka[i]);
      final sisa = angka.length - i - 1;

      if (sisa > 0 && sisa % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }

  void bukaAksi(RiwayatModel item) {
    switch (item.status) {
      case 'Diterima':
        Get.snackbar(
          'Selamat!',
          'Lamaran ${item.posisi} diterima.',
        );
        break;
      case 'Menunggu':
        Get.snackbar(
          'Lamaran sedang diproses',
          'Perusahaan belum memberikan keputusan.',
        );
        break;
      case 'Ditolak':
        Get.snackbar(
          'Status lamaran',
          'Kamu bisa mencoba peluang kerja lainnya.',
        );
        break;
    }
  }
}