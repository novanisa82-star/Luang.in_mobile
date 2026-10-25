import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/riwayat_model.dart';
import '../controllers/riwayat_controller.dart';
import 'detail_riwayat_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late final RiwayatController controller;

  static const Color _background = Color(0xFFF8F7FC);
  static const Color _purple = Color(0xFF8833E6);
  static const Color _dark = Color(0xFF252238);
  static const Color _muted = Color(0xFF898499);

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<RiwayatController>()
        ? Get.find<RiwayatController>()
        : Get.put(RiwayatController());
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);

    return Theme(
      data: baseTheme.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
        primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
          baseTheme.primaryTextTheme,
        ),
      ),
      child: Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader()
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: -0.05, end: 0),

              const SizedBox(height: 22),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => _buildSummary()),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 27),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Daftar lamaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _dark,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${controller.jumlahSemua} lamaran',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Row(
                    children: [
                      _buildTab('Semua', controller.jumlahSemua, 0),
                      const SizedBox(width: 8),
                      _buildTab('Aktif', controller.jumlahAktif, 1),
                      const SizedBox(width: 8),
                      _buildTab('Selesai', controller.jumlahSelesai, 2),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: _purple,
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return _buildErrorState(controller.errorMessage.value);
                  }

                  final items = controller.lamaranTerfilter;

                  if (items.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: _purple,
                    backgroundColor: Colors.white,
                    onRefresh: controller.muatUlang,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return _buildApplicationCard(item)
                            .animate(
                              delay: Duration(
                                milliseconds: 60 * (index.clamp(0, 5)),
                              ),
                            )
                            .fadeIn(duration: 300.ms)
                            .slideY(
                              begin: 0.04,
                              end: 0,
                              duration: 350.ms,
                              curve: Curves.easeOutCubic,
                            );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF20B486),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'AKTIVITAS KAMU',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _muted,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Riwayat Lamaran',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pantau setiap langkah menuju pekerjaanmu.',
                  style: TextStyle(fontSize: 11, color: _muted, height: 1.5),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE4FF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4D4FF)),
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  // SUMMARY
  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7025C8), Color(0xFF9949E9), Color(0xFFAD67F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.19),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perjalanan kariermu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Ringkasan aktivitas lamaran',
                      style: TextStyle(color: Color(0xFFE9D8FF), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(height: 1, color: Colors.white.withOpacity(0.18)),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  '${controller.jumlahSemua}',
                  'Total lamaran',
                  Icons.description_outlined,
                ),
              ),
              _summaryDivider(),
              Expanded(
                child: _summaryItem(
                  '${controller.jumlahAktif}',
                  'Dalam proses',
                  Icons.schedule_rounded,
                ),
              ),
              _summaryDivider(),
              Expanded(
                child: _summaryItem(
                  '${controller.jumlahSelesai}',
                  'Selesai',
                  Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFFE9D8FF)),
        const SizedBox(height: 9),
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE9D8FF),
          ),
        ),
      ],
    );
  }

  Widget _summaryDivider() {
    return Container(
      height: 57,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withOpacity(0.20),
    );
  }

  // FILTER TABS
  Widget _buildTab(String label, int count, int index) {
    final active = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.pilihTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          decoration: BoxDecoration(
            color: active ? _purple : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: active ? _purple : const Color(0xFFECE8F3),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: _purple.withOpacity(0.14),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: active ? Colors.white : _muted,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withOpacity(0.20)
                      : const Color(0xFFF2EEF8),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: active ? Colors.white : _muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // APPLICATION CARD

  Widget _buildApplicationCard(RiwayatModel item) {
    final Color statusColor;
    final Color statusBackground;

    switch (item.status.toLowerCase()) {
      case 'diterima':
        statusColor = PalleteColor.successColor;
        statusBackground = PalleteColor.successBackground;
        break;
      case 'menunggu':
        statusColor = const Color(0xFFAA7100);
        statusBackground = const Color(0xFFFFF2D5);
        break;
      case 'ditolak':
        statusColor = const Color(0xFFD64058);
        statusBackground = const Color(0xFFFFE7EA);
        break;
      default:
        statusColor = PalleteColor.primaryPurple;
        statusBackground = PalleteColor.lightPurple;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFEDE9F4), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292044).withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 49,
                height: 49,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF4EAFF), Color(0xFFE9D9FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  size: 23,
                  color: PalleteColor.primaryPurple,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.posisi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF252238),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.business_rounded,
                          size: 13,
                          color: Color(0xFF898499),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.perusahaan,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF898499),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.status.toLowerCase() == 'diterima'
                            ? Icons.check_circle_rounded
                            : item.status.toLowerCase() == 'ditolak'
                            ? Icons.cancel_rounded
                            : Icons.schedule_rounded,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          item.status,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_rounded,
                size: 12,
                color: Color(0xFF898499),
              ),
              const SizedBox(width: 6),
              Text(
                _formatTanggal(item.tanggal),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF898499),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFF0EDF5)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.upah != null
                          ? 'UPAH PEKERJAAN'
                          : 'INFORMASI LAMARAN',
                      style: const TextStyle(
                        fontSize: 9,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF898499),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.upah != null
                          ? controller.formatUpah(item.upah)
                          : item.informasi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF252238),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(item),
            ],
          ),
        ],
      ),
    );
  }

  // DETAIL BUTTON

  Widget _buildActionButton(RiwayatModel item) {
    final color = item.status.toLowerCase() == 'diterima'
        ? PalleteColor.successColor
        : item.status.toLowerCase() == 'ditolak'
        ? const Color(0xFFD64058)
        : item.status.toLowerCase() == 'menunggu'
        ? const Color(0xFFAA7100)
        : PalleteColor.primaryPurple;

    final String label;

    switch (item.status.toLowerCase()) {
      case 'diterima':
        label = 'Detail';
        break;
      case 'menunggu':
        label = 'Cek status';
        break;
      case 'ditolak':
        label = 'Lihat info';
        break;
      default:
        label = 'Detail';
    }

    return Material(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          Get.to(
            () => DetailRiwayatScreen(
              posisi: item.posisi,
              perusahaan: item.perusahaan,
              status: item.status,
              informasi: item.informasi,
              upah: item.upah?.toString() ?? '',
              tanggal: _formatTanggal(item.tanggal),
            ),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 350),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(width: 5),
              Icon(Icons.arrow_forward_rounded, size: 14, color: color),
            ],
          ),
        ),
      ),
    );
  }

  // ERROR STATE
  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFF0E5FF),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: _purple,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Riwayat belum bisa dimuat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, height: 1.6, color: _muted),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.muatUlang,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Coba lagi',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child:
          SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E5FF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.work_history_rounded,
                        size: 42,
                        color: _purple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Belum ada lamaran',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lowongan yang sudah kamu lamar akan muncul di sini.\n'
                      'Yuk, temukan peluang kerja yang cocok!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.7,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 350.ms)
              .scale(begin: const Offset(0.97, 0.97)),
    );
  }

  // DATE FORMAT
  String _formatTanggal(DateTime tanggal) {
    const bulan = [
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

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }
}
