class HomeModel {
  final int id;
  final int userId;
  final String judul;
  final String deskripsi;
  final double latitude;
  final double longitude;
  final String upah;
  final String durasi;
  final String statusModerasi;
  final String statusLoker;
  final String namaPt;
  final double? rating;
  final int totalRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HomeModel({
    required this.id,
    required this.userId,
    required this.judul,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.upah,
    required this.durasi,
    required this.statusModerasi,
    required this.statusLoker,
    required this.namaPt,
    required this.rating,
    required this.totalRating,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: int.tryParse('${json['id'] ?? 0}') ?? 0,
      userId: int.tryParse('${json['user_id'] ?? 0}') ?? 0,
      judul: json['judul']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
      latitude: double.tryParse('${json['latitude'] ?? 0}') ?? 0,
      longitude: double.tryParse('${json['longitude'] ?? 0}') ?? 0,
      upah: json['upah']?.toString() ?? '0',
      durasi: json['durasi']?.toString() ?? '',
      statusModerasi: json['status_moderasi']?.toString() ?? 'menunggu',
      statusLoker: json['status_loker']?.toString() ?? 'aktif',
      namaPt: json['nama_pt']?.toString() ?? 'Perusahaan',
      rating: double.tryParse('${json['rating'] ?? ''}'),
      totalRating: int.tryParse('${json['total_rating'] ?? 0}') ?? 0,
      createdAt: DateTime.tryParse('${json['created_at'] ?? ''}'),
      updatedAt: DateTime.tryParse('${json['updated_at'] ?? ''}'),
    );
  }
}
