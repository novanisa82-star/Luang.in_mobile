import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luang_in/utils/pallete_color.dart';

class DetailScreen extends StatefulWidget {
  final double? rating;

  const DetailScreen({super.key, this.rating});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final rating = widget.rating;

    return Scaffold(
      backgroundColor: PalleteColor.pageBackground,

      // APP BAR
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
          IconButton(
            tooltip: 'Simpan lowongan',
            icon: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: PalleteColor.textDark,
            ),
            onPressed: () {
              setState(() => _isSaved = !_isSaved);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isSaved
                        ? 'Lowongan berhasil disimpan'
                        : 'Lowongan dihapus dari simpanan',
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Bagikan lowongan',
            icon: const Icon(
              Icons.share_outlined,
              color: PalleteColor.textDark,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur berbagi lowongan belum tersedia'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: PalleteColor.primaryPurple,
              radius: 18,
              child: Icon(
                Icons.person_outline_rounded,
                size: 21,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      // KONTEN UTAMA
      body: SingleChildScrollView(
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
                  'Disetujui Moderasi',
                  PalleteColor.successBackground,
                  PalleteColor.successColor,
                  Icons.verified_rounded,
                ),
                _buildTag(
                  'Loker Aktif',
                  PalleteColor.lightPurple,
                  PalleteColor.primaryPurple,
                  Icons.circle,
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.12, end: 0),

            const SizedBox(height: 14),

            const Text(
                  'Barista Espresso Utama',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: PalleteColor.textDark,
                    height: 1.2,
                  ),
                )
                .animate()
                .fadeIn(delay: 100.ms, duration: 450.ms)
                .slideY(begin: 0.12, end: 0),

            const SizedBox(height: 12),

            // TANGGAL
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                _buildInfo(
                  Icons.calendar_today_outlined,
                  'Dibuat: 08 Sep 2024',
                ),
                _buildInfo(Icons.update_rounded, 'Diperbarui: 06 Okt 2024'),
              ],
            ).animate().fadeIn(delay: 150.ms),

            // RATING HANYA TAMPIL JIKA ADA
            if (rating != null) ...[
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
                        '${rating.toStringAsFixed(1)} / 5.0',
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
                      color: PalleteColor.primaryPurple.withOpacity(0.07),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: PalleteColor.primaryPurple.withOpacity(0.04),
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: PalleteColor.primaryPurple,
                                  size: 17,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '5 Jam',
                                  style: TextStyle(
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

                      // RESPONSIVE AGAR TIDAK OVERFLOW
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 5,
                        children: [
                          const Text(
                            'Rp380.000',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: PalleteColor.primaryPurple,
                              letterSpacing: -1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7),
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
                        color: PalleteColor.primaryPurple.withOpacity(0.10),
                        height: 1,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusCard(
                              Icons.verified_user_outlined,
                              'Status Moderasi',
                              'Disetujui',
                              PalleteColor.successColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatusCard(
                              Icons.work_outline_rounded,
                              'Status Loker',
                              'Aktif / Terbuka',
                              PalleteColor.primaryPurple,
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dibutuhkan Barista Espresso Utama untuk mengelola '
                        'persiapan, penyajian minuman kopi berbasis espresso '
                        'dengan kalibrasi standar tinggi, serta menjaga '
                        'kebersihan bar station sepanjang durasi kerja.',
                        style: TextStyle(
                          color: PalleteColor.textGrey,
                          height: 1.65,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Bertanggung jawab dalam melayani pesanan pelanggan '
                        'secara cekatan dan ramah, melakukan pencatatan '
                        'inventaris bahan baku espresso, serta memastikan '
                        'alur kerja counter tetap rapi sesuai SOP yang berlaku.',
                        style: TextStyle(
                          color: PalleteColor.textGrey,
                          height: 1.65,
                          fontSize: 15,
                        ),
                      ),
                    ],
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
                          child: const Text(
                            '-6.2255, 106.8097',
                            style: TextStyle(
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
                        child: const Row(
                          children: [
                            Icon(
                              Icons.my_location_rounded,
                              size: 19,
                              color: PalleteColor.primaryPurple,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Latitude: -6.225500\n'
                                'Longitude: 106.809700',
                                style: TextStyle(
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

                      // ILUSTRASI PETA
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 230,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(painter: _MapPainter()),
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
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.near_me_rounded,
                                        size: 17,
                                        color: PalleteColor.primaryPurple,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'GPS Terverifikasi',
                                        style: TextStyle(
                                          color: PalleteColor.primaryPurple,
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
                                        onPressed: () {
                                          _showLocationMessage(
                                            'Koordinat: -6.2255, 106.8097',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.map_outlined,
                                          size: 18,
                                        ),
                                        label: const Text('Lihat Lokasi'),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              PalleteColor.primaryPurple,
                                          side: BorderSide(
                                            color: PalleteColor.primaryPurple
                                                .withOpacity(0.2),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          _showLocationMessage(
                                            'Tambahkan url Google Maps untuk '
                                            'mengaktifkan petunjuk arah.',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.navigation_rounded,
                                          size: 18,
                                        ),
                                        label: const Text('Petunjuk Arah'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              PalleteColor.primaryPurple,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
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

      // 5. BOTTOM BAR LAMAR SEKARANG
      bottomNavigationBar: Container(
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
                              const Text(
                                'Rp380.000',
                                style: TextStyle(
                                  color: PalleteColor.primaryPurple,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '/5 jam',
                                style: TextStyle(
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
                        onPressed: () {
                          _showLocationMessage(
                            'Fitur lamaran perlu dihubungkan dengan '
                            'halaman formulir lamaran.',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PalleteColor.primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: PalleteColor.primaryPurple.withOpacity(
                            0.25,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Lamar Sekarang',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            Icon(Icons.arrow_forward_rounded, size: 21),
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
      ),
    );
  }

  // TAG STATUS
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

  // INFORMASI TANGGAL
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

  // KARTU STATUS
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

  // KARTU SECTION
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

  // PESAN SEMENTARA
  void _showLocationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ILUSTRASI PETA SEDERHANA
// Untuk peta Google Maps asli, gunakan package google_maps_flutter.
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

    // Jalan utama
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

    // Garis jalan kecil
    for (int i = 1; i <= 5; i++) {
      final y = size.height * i / 6;

      canvas.drawLine(Offset(0, y), Offset(size.width, y + 15), thinRoadPaint);
    }

    for (int i = 1; i <= 6; i++) {
      final x = size.width * i / 7;

      canvas.drawLine(Offset(x, 0), Offset(x - 20, size.height), thinRoadPaint);
    }

    // Label area
    _drawLabel(
      canvas,
      'Jakarta',
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
