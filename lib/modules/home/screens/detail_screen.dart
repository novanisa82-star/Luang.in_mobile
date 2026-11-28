import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:luang_in/data/models/home_model.dart';
import 'package:luang_in/modules/home/controllers/detail_controller.dart';
import 'package:luang_in/utils/pallete_color.dart';

class DetailScreen extends StatelessWidget {
  final int? jobId;
  final HomeModel? job;
  final double? rating;

  const DetailScreen({super.key, this.jobId, this.job, this.rating});

  @override
  Widget build(BuildContext context) {
    final tag = 'detail_${jobId ?? job?.id ?? 'default'}';

    return GetBuilder<DetailController>(
      init: DetailController(
        initialJobId: jobId,
        initialJob: job,
        initialRating: rating,
      ),
      tag: tag,
      builder: (controller) {
        return Scaffold(
          backgroundColor: PalleteColor.pageBackground,
          appBar: AppBar(
            backgroundColor: PalleteColor.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: PalleteColor.textDark,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Rincian Lowongan',
              style: TextStyle(
                color: PalleteColor.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              Obx(
                () => IconButton(
                  tooltip: 'Simpan lowongan',
                  icon: Icon(
                    controller.isSaved.value
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: PalleteColor.textDark,
                  ),
                  onPressed: () => controller.toggleSave(context),
                ),
              ),
              IconButton(
                tooltip: 'Muat ulang',
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: PalleteColor.textDark,
                ),
                onPressed: controller.fetchJobDetail,
              ),
            ],
          ),
          body: Obx(() {
            final currentJob = controller.job.value;
            final currentRating = controller.effectiveRating;

            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PalleteColor.primaryPurple,
                ),
              );
            }

            if (controller.errorMessage.value != null && currentJob == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Color(0xFFD94B5B),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.errorMessage.value!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PalleteColor.textDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: controller.fetchJobDetail,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PalleteColor.primaryPurple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (currentJob == null) {
              return const Center(child: Text('Data lowongan tidak tersedia.'));
            }

            return RefreshIndicator(
              color: PalleteColor.primaryPurple,
              onRefresh: controller.fetchJobDetail,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. STATUS DAN JUDUL
                    Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildTag(
                              controller.moderasiLabel(
                                currentJob.statusModerasi,
                              ),
                              currentJob.statusModerasi == 'disetujui'
                                  ? PalleteColor.successBackground
                                  : PalleteColor.lightPurple,
                              currentJob.statusModerasi == 'disetujui'
                                  ? PalleteColor.successColor
                                  : PalleteColor.primaryPurple,
                              Icons.verified_rounded,
                            ),
                            _buildTag(
                              controller.lokerLabel(currentJob.statusLoker),
                              currentJob.statusLoker == 'aktif'
                                  ? PalleteColor.lightPurple
                                  : const Color(0xFFF3F4F6),
                              currentJob.statusLoker == 'aktif'
                                  ? PalleteColor.primaryPurple
                                  : PalleteColor.textGrey,
                              Icons.circle,
                            ),
                            if (currentJob.sudahMelamar)
                              _buildTag(
                                controller.statusLamaranLabel(
                                  currentJob.statusLamaran,
                                ),
                                const Color(0xFFDCFCE7),
                                const Color(0xFF15803D),
                                Icons.check_circle_rounded,
                              ),
                            if (currentJob.sisaWaktu != null &&
                                currentJob.sisaWaktu!.isNotEmpty &&
                                currentJob.deadlinePendaftaran != null)
                              _buildTag(
                                currentJob.sisaWaktu!,
                                const Color(0xFFFFF3E0),
                                const Color(0xFFE65100),
                                Icons.hourglass_bottom_rounded,
                              ),
                          ],
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.12, end: 0),

                    const SizedBox(height: 14),

                    Text(
                          currentJob.judul,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: PalleteColor.textDark,
                            height: 1.2,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 450.ms)
                        .slideY(begin: 0.12, end: 0),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.apartment_rounded,
                          size: 16,
                          color: PalleteColor.primaryPurple,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            currentJob.namaPt,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: PalleteColor.textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // TANGGAL & PELAMAR
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        _buildInfo(
                          Icons.calendar_today_outlined,
                          'Dibuat: ${controller.formatDate(currentJob.createdAt)}',
                        ),
                        _buildInfo(
                          Icons.update_rounded,
                          'Diperbarui: ${controller.formatDate(currentJob.updatedAt)}',
                        ),
                        _buildInfo(
                          Icons.event_available_rounded,
                          'Batas Lamaran: ${controller.formatDateTime(currentJob.deadlinePendaftaran)}',
                        ),
                        _buildInfo(
                          Icons.people_outline_rounded,
                          '${currentJob.totalPelamar} Pelamar',
                        ),
                      ],
                    ).animate().fadeIn(delay: 150.ms),

                    // RATING HANYA TAMPIL JIKA ADA
                    if (currentRating != null) ...[
                      const SizedBox(height: 12),
                      Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 19,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${currentRating.toStringAsFixed(1)} / 5.0',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: PalleteColor.textDark,
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(duration: 350.ms)
                          .scale(begin: const Offset(0.95, 0.95)),
                    ],

                    const SizedBox(height: 20),

                    // 2. KARTU UPAH
                    Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F0FF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: PalleteColor.primaryPurple.withOpacity(
                                0.07,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: PalleteColor.primaryPurple.withOpacity(
                                  0.04,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
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
                                      'UPAH PEKERJAAN',
                                      style: TextStyle(
                                        color: PalleteColor.primaryPurple,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.timer_outlined,
                                          color: PalleteColor.primaryPurple,
                                          size: 17,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          currentJob.durasi.isNotEmpty
                                              ? currentJob.durasi
                                              : 'Fleksibel',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: PalleteColor.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.end,
                                spacing: 5,
                                children: [
                                  Text(
                                    controller.formatRupiah(currentJob.upah),
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      color: PalleteColor.primaryPurple,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child: Text(
                                      '/pekerjaan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PalleteColor.textGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Divider(
                                color: PalleteColor.primaryPurple.withOpacity(
                                  0.10,
                                ),
                                height: 1,
                              ),

                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatusCard(
                                      Icons.verified_user_outlined,
                                      'Status Moderasi',
                                      currentJob.statusModerasi == 'disetujui'
                                          ? 'Disetujui'
                                          : currentJob.statusModerasi,
                                      currentJob.statusModerasi == 'disetujui'
                                          ? PalleteColor.successColor
                                          : PalleteColor.primaryPurple,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildStatusCard(
                                      Icons.work_outline_rounded,
                                      'Status Loker',
                                      currentJob.statusLoker == 'aktif'
                                          ? 'Aktif / Terbuka'
                                          : 'Ditutup',
                                      currentJob.statusLoker == 'aktif'
                                          ? PalleteColor.primaryPurple
                                          : PalleteColor.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 180.ms, duration: 500.ms)
                        .slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 18),

                    // 3. DESKRIPSI PEKERJAAN
                    _buildSection(
                          icon: Icons.description_outlined,
                          title: 'Deskripsi Pekerjaan',
                          child: Text(
                            currentJob.deskripsi.isNotEmpty
                                ? currentJob.deskripsi
                                : 'Tidak ada deskripsi tambahan untuk pekerjaan ini.',
                            style: const TextStyle(
                              color: PalleteColor.textGrey,
                              height: 1.65,
                              fontSize: 15,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 250.ms, duration: 500.ms)
                        .slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 18),

                    // 4. LOKASI DAN KOORDINAT
                    _buildSection(
                          icon: Icons.location_on_outlined,
                          title: 'Koordinat & Lokasi Peta',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PalleteColor.lightPurple,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${currentJob.latitude.toStringAsFixed(4)}, ${currentJob.longitude.toStringAsFixed(4)}',
                                    style: const TextStyle(
                                      color: PalleteColor.primaryPurple,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: PalleteColor.inputBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.my_location_rounded,
                                      size: 19,
                                      color: PalleteColor.primaryPurple,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Latitude: ${currentJob.latitude.toStringAsFixed(6)}\n'
                                        'Longitude: ${currentJob.longitude.toStringAsFixed(6)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          height: 1.7,
                                          fontWeight: FontWeight.w600,
                                          color: PalleteColor.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // ILUSTRASI PETA (KETUK UNTUK BUKA GOOGLE MAPS)
                              GestureDetector(
                                onTap: () => controller.openGoogleMaps(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    height: 230,
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: _MapPainter(),
                                          ),
                                        ),

                                        const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 43,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                'Lokasi Pekerjaan',
                                                style: TextStyle(
                                                  color: PalleteColor.textDark,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 9,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.08),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.near_me_rounded,
                                                  size: 17,
                                                  color: PalleteColor
                                                      .primaryPurple,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Buka di Google Maps',
                                                  style: TextStyle(
                                                    color: PalleteColor
                                                        .primaryPurple,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 12,
                                          right: 12,
                                          bottom: 12,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  onPressed: () => controller
                                                      .openGoogleMaps(),
                                                  icon: const Icon(
                                                    Icons.map_outlined,
                                                    size: 18,
                                                  ),
                                                  label: const Text(
                                                    'Lihat Lokasi',
                                                  ),
                                                  style: OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        PalleteColor
                                                            .primaryPurple,
                                                    side: BorderSide(
                                                      color: PalleteColor
                                                          .primaryPurple
                                                          .withOpacity(0.2),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      controller.openGoogleMaps(
                                                        directions: true,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.navigation_rounded,
                                                    size: 18,
                                                  ),
                                                  label: const Text(
                                                    'Petunjuk Arah',
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        PalleteColor
                                                            .primaryPurple,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 320.ms, duration: 500.ms)
                        .slideY(begin: 0.08, end: 0),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }),
          bottomNavigationBar: Obx(() {
            final currentJob = controller.job.value;
            if (currentJob == null) return const SizedBox.shrink();

            final isApplying = controller.isApplying.value;

            return Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              decoration: BoxDecoration(
                color: PalleteColor.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Upah',
                                style: TextStyle(
                                  color: PalleteColor.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 3),
                              FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    Text(
                                      controller.formatRupiah(currentJob.upah),
                                      style: const TextStyle(
                                        color: PalleteColor.primaryPurple,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      currentJob.durasi.isNotEmpty
                                          ? '/${currentJob.durasi}'
                                          : '/pekerjaan',
                                      style: const TextStyle(
                                        color: PalleteColor.textGrey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed:
                                  (currentJob.sudahMelamar ||
                                      currentJob.statusLoker != 'aktif' ||
                                      isApplying)
                                  ? null
                                  : () => controller.confirmAndApply(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentJob.sudahMelamar
                                    ? const Color(0xFF16A34A)
                                    : PalleteColor.primaryPurple,
                                disabledBackgroundColor: currentJob.sudahMelamar
                                    ? const Color(0xFFDCFCE7)
                                    : Colors.grey.shade300,
                                foregroundColor: Colors.white,
                                disabledForegroundColor: currentJob.sudahMelamar
                                    ? const Color(0xFF15803D)
                                    : Colors.grey.shade600,
                                elevation: currentJob.sudahMelamar ? 0 : 3,
                                shadowColor: PalleteColor.primaryPurple
                                    .withOpacity(0.25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              child: isApplying
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            currentJob.sudahMelamar
                                                ? controller.statusLamaranLabel(
                                                    currentJob.statusLamaran,
                                                  )
                                                : (currentJob.statusLoker !=
                                                          'aktif'
                                                      ? 'Loker Ditutup'
                                                      : 'Lamar Sekarang'),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        if (!currentJob.sudahMelamar &&
                                            currentJob.statusLoker ==
                                                'aktif') ...[
                                          const SizedBox(width: 7),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 21,
                                          ),
                                        ],
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          color: PalleteColor.successColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bebas biaya pendaftaran • Pembayaran dijamin '
                            'aman via WorkLoop Escrow',
                            style: TextStyle(
                              color: PalleteColor.textGrey,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildTag(
    String label,
    Color background,
    Color foreground,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: PalleteColor.textGrey),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: PalleteColor.textGrey),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    IconData icon,
    String title,
    String status,
    Color color,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 82),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: PalleteColor.textGrey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: PalleteColor.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PalleteColor.borderColor.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: PalleteColor.primaryPurple, size: 25),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: PalleteColor.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE7EBE9);

    canvas.drawRect(Offset.zero & size, background);

    final parkPaint = Paint()..color = const Color(0xFFD3E6D3);

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25),
      45,
      parkPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.84, size.height * 0.35),
      36,
      parkPaint,
    );

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFFCDD4D2)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final road1 = Path()
      ..moveTo(-10, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.45,
        size.width + 10,
        size.height * 0.57,
      );

    final road2 = Path()
      ..moveTo(size.width * 0.35, -10)
      ..quadraticBezierTo(
        size.width * 0.53,
        size.height * 0.45,
        size.width * 0.67,
        size.height + 10,
      );

    canvas.drawPath(road1, roadPaint);
    canvas.drawPath(road2, roadPaint);

    for (int i = 1; i <= 5; i++) {
      final y = size.height * i / 6;

      canvas.drawLine(Offset(0, y), Offset(size.width, y + 15), thinRoadPaint);
    }

    for (int i = 1; i <= 6; i++) {
      final x = size.width * i / 7;

      canvas.drawLine(Offset(x, 0), Offset(x - 20, size.height), thinRoadPaint);
    }

    _drawLabel(
      canvas,
      'Area Peta',
      Offset(size.width * 0.12, size.height * 0.12),
    );

    _drawLabel(
      canvas,
      'Area Kota',
      Offset(size.width * 0.69, size.height * 0.72),
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF66716D),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
