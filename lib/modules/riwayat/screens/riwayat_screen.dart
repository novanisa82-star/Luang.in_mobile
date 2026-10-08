import 'package:flutter/material.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  int selectedTab = 0;

  final List<Map<String, dynamic>> lamaran = [
    {
      'posisi': 'Barista Espresso Utama',
      'perusahaan': 'Tanamera Coffee • SCBD',
      'status': 'Diterima',
      'warna': Color(0xFFB8F5DD),
      'teks': Color(0xFF168B67),
      'gaji': 'Upah: Rp380.000',
    },
    {
      'posisi': 'Kru Pasar Kreatif',
      'perusahaan': 'Bazar Akhir Pekan Jakarta',
      'status': 'Menunggu',
      'warna': Color(0xFFFFEDB8),
      'teks': Color(0xFFAA7100),
      'gaji': 'Dilamar 2 jam lalu',
    },
    {
      'posisi': 'Teknisi Panggung Acara',
      'perusahaan': 'Soundstage Arena',
      'status': 'Ditolak',
      'warna': Color(0xFFFFE0E5),
      'teks': Color(0xFFD94A60),
      'gaji': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'Riwayat Lamaran',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202A3A),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Pantau status lamaran kerja Anda secara langsung.',
                style: TextStyle(fontSize: 11, color: Color(0xFF8994A6)),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _tab('Semua (6)', 0),
                  const SizedBox(width: 14),
                  _tab('Aktif (2)', 1),
                  const SizedBox(width: 14),
                  _tab('Selesai (4)', 2),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFFE7EBF2), height: 1),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 16),
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final item = _filtered[index];
                  return _card(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filtered {
    if (selectedTab == 1) {
      return lamaran
          .where((e) => e['status'] == 'Menunggu' || e['status'] == 'Diterima')
          .toList();
    }

    if (selectedTab == 2) {
      return lamaran
          .where((e) => e['status'] == 'Ditolak' || e['status'] == 'Diterima')
          .toList();
    }

    return lamaran;
  }

  Widget _tab(String title, int index) {
    final active = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? const Color(0xFF963BEB)
                    : const Color(0xFF8994A6),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              width: 45,
              color: active ? const Color(0xFF963BEB) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(Map<String, dynamic> item) {
    final status = item['status'];

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE7EBF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['posisi'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF273346),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['perusahaan'],
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF8994A6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: item['warna'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status == 'Diterima'
                          ? Icons.check_circle_outline
                          : status == 'Menunggu'
                          ? Icons.access_time
                          : Icons.cancel_outlined,
                      size: 10,
                      color: item['teks'],
                    ),
                    const SizedBox(width: 3),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: item['teks'],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (status == 'Diterima')
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['gaji'],
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF69758A),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Instruksi kerja dibuka')),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Buka Instruksi Kerja',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF963BEB),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 11,
                        color: Color(0xFF963BEB),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else if (status == 'Menunggu')
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['gaji'],
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF8994A6),
                    ),
                  ),
                ),
                const Text(
                  'Sedang Ditinjau',
                  style: TextStyle(fontSize: 9, color: Color(0xFF8994A6)),
                ),
              ],
            )
          else
            const Text(
              'Posisi telah terisi oleh pelamar lain. Tetap semangat!',
              style: TextStyle(fontSize: 8, color: Color(0xFF8994A6)),
            ),
        ],
      ),
    );
  }
}
