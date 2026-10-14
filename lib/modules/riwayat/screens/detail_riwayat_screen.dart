import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:luang_in/utils/pallete_color.dart';

class DetailRiwayatScreen extends StatelessWidget {
  final String posisi;
  final String perusahaan;
  final String status;
  final String informasi;
  final String upah;
  final String tanggal;
  final String deskripsi;
  final String waktuKerja;
  final String cv;

  const DetailRiwayatScreen({
    super.key,
    required this.posisi,
    required this.perusahaan,
    required this.status,
    required this.informasi,
    required this.upah,
    required this.tanggal,
    this.deskripsi = '',
    this.waktuKerja = '',
    this.cv = '',
  });

  Color get warnaStatus {
    switch (status.toLowerCase()) {
      case 'diterima':
        return PalleteColor.successColor;
      case 'ditolak':
        return Colors.red.shade600;
      default:
        return const Color(0xFFDA8A16);
    }
  }

  Color get latarStatus {
    switch (status.toLowerCase()) {
      case 'diterima':
        return PalleteColor.successBackground;
      case 'ditolak':
        return const Color(0xFFFFEEEE);
      default:
        return const Color(0xFFFFF5E5);
    }
  }

  IconData get ikonStatus {
    switch (status.toLowerCase()) {
      case 'diterima':
        return Icons.check_circle_rounded;
      case 'ditolak':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  String get judulStatus {
    switch (status.toLowerCase()) {
      case 'diterima':
        return 'Lamaran Diterima';
      case 'ditolak':
        return 'Lamaran Belum Berhasil';
      default:
        return 'Lamaran Sedang Ditinjau';
    }
  }

  String get deskripsiStatus {
    switch (status.toLowerCase()) {
      case 'diterima':
        return 'Selamat! Lamaran kamu diterima. Periksa informasi tindak lanjut dari perusahaan.';
      case 'ditolak':
        return 'Lamaran ini belum berhasil. Tetap semangat mencari peluang pekerjaan lainnya.';
      default:
        return 'Lamaran kamu sedang diproses. Periksa kembali secara berkala untuk mengetahui pembaruan status.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.pageBackground,
      appBar: AppBar(
        backgroundColor: PalleteColor.pageBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: PalleteColor.textDark,
          ),
        ),
        title: const Text(
          'Detail Lamaran',
          style: TextStyle(
            color: PalleteColor.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJobCard()
                  .animate()
                  .fadeIn(duration: 450.ms)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 450.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 18),
              _buildStatusCard()
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 450.ms)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    delay: 100.ms,
                    duration: 450.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 26),
              _buildSectionTitle(
                'Informasi Lamaran',
              ).animate().fadeIn(delay: 160.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildInformationCard()
                  .animate()
                  .fadeIn(delay: 180.ms, duration: 450.ms)
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    delay: 180.ms,
                    duration: 450.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 26),
              _buildSectionTitle(
                'Deskripsi Pekerjaan',
              ).animate().fadeIn(delay: 240.ms, duration: 400.ms),
              const SizedBox(height: 14),
              _buildDescriptionCard()
                  .animate()
                  .fadeIn(delay: 260.ms, duration: 450.ms)
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    delay: 260.ms,
                    duration: 450.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 28),
              _buildBackButton()
                  .animate()
                  .fadeIn(delay: 320.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.05,
                    end: 0,
                    delay: 320.ms,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: PalleteColor.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: PalleteColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: PalleteColor.primaryPurple.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: PalleteColor.gradient,
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: PalleteColor.primaryPurple.withOpacity(0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
              const Spacer(),
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: latarStatus,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(ikonStatus, size: 15, color: warnaStatus),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: warnaStatus,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    delay: 1200.ms,
                    duration: 1000.ms,
                    color: Colors.white.withOpacity(0.6),
                  ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            posisi,
            style: const TextStyle(
              color: PalleteColor.textDark,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.business_outlined,
                size: 19,
                color: PalleteColor.textGrey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  perusahaan,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PalleteColor.textGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: PalleteColor.borderColor),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: PalleteColor.primaryPurple,
                size: 17,
              ),
              const SizedBox(width: 9),
              const Text(
                'Tanggal melamar',
                style: TextStyle(color: PalleteColor.textGrey, fontSize: 12),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  tanggal,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: PalleteColor.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: latarStatus,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: warnaStatus.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PalleteColor.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(ikonStatus, color: warnaStatus, size: 24),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judulStatus,
                  style: TextStyle(
                    color: warnaStatus,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  deskripsiStatus,
                  style: const TextStyle(
                    color: PalleteColor.textDark,
                    fontSize: 13,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: PalleteColor.textDark,
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: PalleteColor.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PalleteColor.borderColor),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.calendar_month_outlined,
            label: 'Tanggal Melamar',
            value: tanggal,
          ),
          if (upah.isNotEmpty)
            _DetailRow(
              icon: Icons.payments_outlined,
              label: 'Upah',
              value: upah,
            ),
          if (waktuKerja.isNotEmpty)
            _DetailRow(
              icon: Icons.schedule_rounded,
              label: 'Waktu Kerja',
              value: waktuKerja,
            ),
          if (cv.isNotEmpty)
            _DetailRow(
              icon: Icons.description_outlined,
              label: 'CV',
              value: cv,
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    final isiDeskripsi = deskripsi.isNotEmpty
        ? deskripsi
        : informasi.isNotEmpty
        ? informasi
        : 'Belum ada deskripsi pekerjaan.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PalleteColor.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PalleteColor.borderColor),
      ),
      child: Text(
        isiDeskripsi,
        style: const TextStyle(
          fontSize: 14,
          height: 1.8,
          color: PalleteColor.textGrey,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: Get.back,
        icon: const Icon(Icons.arrow_back_rounded, size: 19),
        label: const Text('Kembali ke Riwayat'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: PalleteColor.primaryPurple,
          foregroundColor: PalleteColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PalleteColor.lightPurple,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: PalleteColor.primaryPurple, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PalleteColor.textGrey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PalleteColor.textDark,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
