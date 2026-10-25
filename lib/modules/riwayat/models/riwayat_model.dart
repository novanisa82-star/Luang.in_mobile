
class RiwayatModel {
  final int id;
  final String posisi;
  final String perusahaan;
  final String status;
  final String informasi;
  final int? upah;
  final DateTime tanggal;

  const RiwayatModel({
    required this.id,
    required this.posisi,
    required this.perusahaan,
    required this.status,
    required this.informasi,
    required this.tanggal,
    this.upah,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      posisi: json['posisi']?.toString() ?? 'Lowongan',
      perusahaan: json['perusahaan']?.toString() ?? 'Perusahaan',
      status: _normalisasiStatus(json['status']?.toString()),
      informasi: json['informasi']?.toString() ?? '',
      upah: _parseUpah(json['upah']),
      tanggal: DateTime.tryParse(json['tanggal']?.toString() ?? '')
          ?? DateTime.now(),
    );
  }

  static String _normalisasiStatus(String? value) {
    switch (value?.toLowerCase()) {
      case 'menunggu':
        return 'Menunggu';
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return value ?? 'Menunggu';
    }
  }

  static int? _parseUpah(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.round();

    final angka = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(angka);
  }

  bool get isAktif => status == 'Menunggu';

  bool get isSelesai =>
      status == 'Diterima' || status == 'Ditolak';
}
