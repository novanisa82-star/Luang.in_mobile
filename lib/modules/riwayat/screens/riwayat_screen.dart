import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:luang_in/utils/pallete_color.dart';
import '../controllers/riwayat_controller.dart';
import 'package:luang_in/modules/riwayat/screens/detail_riwayat_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late final RiwayatController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<RiwayatController>()
        ? Get.find<RiwayatController>()
        : Get.put(RiwayatController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aktivitas kamu',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A8799),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Riwayat Lamaran',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF252238),
                                letterSpacing: -0.6,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Pantau perkembangan kariermu di sini.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE4FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.08, end: 0, curve: Curves.easeOutCubic),

            // RINGKASAN LAMARAN
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7925D5), Color(0xFF9D4AEF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8C3DE0).withOpacity(0.20),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Perjalanan lamaranmu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.trending_up_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Ringkasan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
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
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 100.ms, duration: 500.ms)
                .scale(
                  begin: const Offset(0.97, 0.97),
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 24),

            // JUDUL DAFTAR
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Daftar lamaran',
                style: TextStyle(
                  color: Color(0xFF252238),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 13),

            // TAB FILTER
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

            // LIST LAMARAN
            Expanded(
              child: Obx(() {
                final items = controller.lamaranTerfilter;

                if (items.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return _buildApplicationCard(item)
                        .animate(delay: Duration(milliseconds: 70 * index))
                        .fadeIn(duration: 350.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ITEM RINGKASAN
  Widget _summaryItem(String value, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 19),
        const SizedBox(height: 9),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
        ),
      ],
    );
  }

  Widget _summaryDivider() {
    return Container(
      height: 65,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withOpacity(0.20),
    );
  }

  // TAB FILTER
  Widget _buildTab(String label, int count, int index) {
    final active = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.pilihTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
          decoration: BoxDecoration(
            color: active ? PalleteColor.primaryPurple : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? PalleteColor.primaryPurple
                  : const Color(0xFFECE8F3),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: PalleteColor.primaryPurple.withOpacity(0.16),
                      blurRadius: 10,
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
                    color: active ? Colors.white : const Color(0xFF777387),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withOpacity(0.20)
                      : const Color(0xFFF0ECF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: active ? Colors.white : const Color(0xFF777387),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // KARTU LAMARAN
  Widget _buildApplicationCard(LamaranModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFEDE9F4), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292044).withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IKON PERUSAHAAN
              Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E7FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: PalleteColor.primaryPurple,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),

              // JUDUL DAN PERUSAHAAN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.posisi,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF29243B),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.perusahaan,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF898499),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // BADGE STATUS
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: item.warnaStatus,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.ikonStatus,
                      color: item.warnaTeksStatus,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item.status,
                      style: TextStyle(
                        color: item.warnaTeksStatus,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.access_time_rounded,
                size: 13,
                color: Color(0xFF9994A8),
              ),
              const SizedBox(width: 4),
              Text(
                _formatTanggal(item.tanggal),
                style: const TextStyle(fontSize: 10, color: Color(0xFF9994A8)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(height: 1, color: Colors.grey.shade100),

          const SizedBox(height: 13),

          // INFORMASI UPAH DAN AKSI
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.upah != null ? 'Upah pekerjaan' : 'Informasi',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9994A8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.upah != null
                          ? controller.formatUpah(item.upah)
                          : item.informasi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF302744),
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

  // TOMBOL SESUAI STATUS

  Widget _buildActionButton(LamaranModel item) {
    final Color color = item.warnaTeksStatus;

    String label;

    switch (item.status) {
      case 'Diterima':
        label = 'Lihat detail';
        break;
      case 'Menunggu':
        label = 'Cek status';
        break;
      default:
        label = 'Lihat info';
    }

    return GestureDetector(
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          color: item.warnaStatus,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_rounded, size: 13, color: color),
          ],
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFF0E5FF),
                borderRadius: BorderRadius.circular(27),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 40,
                color: PalleteColor.primaryPurple,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Belum ada lamaran',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF29243B),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Lamaran yang sesuai dengan filter ini\nakan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.6,
                color: Color(0xFF898499),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.96, 0.96)),
    );
  }

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
