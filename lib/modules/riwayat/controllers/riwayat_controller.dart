
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LamaranModel {
  final String posisi;
  final String perusahaan;
  final String status;
  final String informasi;
  final int? upah;
  final DateTime tanggal;

  const LamaranModel({
    required this.posisi,
    required this.perusahaan,
    required this.status,
    required this.informasi,
    required this.tanggal,
    this.upah,
  });

  bool get isAktif => status == 'Menunggu';

  bool get isSelesai =>
      status == 'Diterima' || status == 'Ditolak';

  Color get warnaStatus {
    switch (status) {
      case 'Diterima':
        return const Color(0xFFE0F8ED);
      case 'Menunggu':
        return const Color(0xFFFFF2D5);
      case 'Ditolak':
        return const Color(0xFFFFE7EA);
      default:
        return const Color(0xFFF0E5FF);
    }
  }

  Color get warnaTeksStatus {
    switch (status) {
      case 'Diterima':
        return const Color(0xFF13845F);
      case 'Menunggu':
        return const Color(0xFFAA7100);
      case 'Ditolak':
        return const Color(0xFFD64058);
      default:
        return const Color(0xFF963BEB);
    }
  }

  IconData get ikonStatus {
    switch (status) {
      case 'Diterima':
        return Icons.check_circle_rounded;
      case 'Menunggu':
        return Icons.schedule_rounded;
      case 'Ditolak':
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}

class RiwayatController extends GetxController {
  final RxInt selectedTab = 0.obs;

  final RxList<LamaranModel> lamaran = <LamaranModel>[
    LamaranModel(
      posisi: 'Barista Espresso Utama',
      perusahaan: 'Tanamera Coffee • SCBD',
      status: 'Diterima',
      informasi: 'Lamaran berhasil diterima',
      upah: 380000,
      tanggal: DateTime(2026, 10, 8),
    ),
    LamaranModel(
      posisi: 'Kru Pasar Kreatif',
      perusahaan: 'Bazar Akhir Pekan Jakarta',
      status: 'Menunggu',
      informasi: 'Menunggu konfirmasi perusahaan',
      upah: 250000,
      tanggal: DateTime(2026, 10, 12),
    ),
    LamaranModel(
      posisi: 'Teknisi Panggung Acara',
      perusahaan: 'Soundstage Arena',
      status: 'Ditolak',
      informasi: 'Belum sesuai dengan kebutuhan',
      tanggal: DateTime(2026, 10, 5),
    ),
  ].obs;

  int get jumlahSemua => lamaran.length;

  int get jumlahAktif =>
      lamaran.where((item) => item.isAktif).length;

  int get jumlahSelesai =>
      lamaran.where((item) => item.isSelesai).length;

  List<LamaranModel> get lamaranTerfilter {
  switch (selectedTab.value) {
    case 1:
      return lamaran
          .where((item) => item.status == 'Menunggu')
          .toList();

    case 2:
      return lamaran
          .where(
            (item) =>
                item.status == 'Diterima' ||
                item.status == 'Ditolak',
          )
          .toList();
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

    return 'Rp${buffer.toString()}';
  }

  void bukaAksi(LamaranModel item) {
    switch (item.status) {
      case 'Diterima':
        Get.snackbar(
          'Selamat!',
          'Lamaran ${item.posisi} diterima. '
              'Halaman instruksi kerja bisa dihubungkan di sini.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE0F8ED),
          colorText: const Color(0xFF13845F),
          margin: const EdgeInsets.all(16),
        );
        break;

      case 'Menunggu':
        Get.snackbar(
          'Lamaran sedang diproses',
          'Perusahaan belum memberikan keputusan.',
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        break;

      case 'Ditolak':
        Get.snackbar(
          'Status lamaran',
          'Kamu bisa mencoba peluang kerja lainnya.',
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        break;
    }
  }
}
