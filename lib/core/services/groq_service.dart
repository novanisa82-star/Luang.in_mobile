import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../config/groq_config.dart';
import '../../data/models/home_model.dart';

class GroqService {
  /// Mengirim prompt atau CV ke Groq API
  Future<Map<String, dynamic>> sendRequest({
    required String userPrompt,
    String? base64Image,
    String? imageMimeType,
    String? documentText,
    List<Map<String, String>> conversationHistory = const [],
    List<HomeModel> availableJobs = const [],
    String? userLocationName,
    double? userLatitude,
    double? userLongitude,
  }) async {
    final apiKey = GroqConfig.getApiKey();

    if (apiKey.isEmpty) {
      throw Exception(
        'API Key Groq belum diatur di file .env.\n\n'
        'Silakan buka file `.env` pada proyek dan isi:\n'
        'GROQ_API_KEY=gsk_...\n\n'
        'Kemudian restart aplikasi (stop lalu jalankan kembali) agar perubahan .env terbaca.',
      );
    }

    final systemInstruction = _buildSystemInstruction(
      availableJobs: availableJobs,
      userLocationName: userLocationName,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
    );

    // Siapkan daftar pesan
    final messages = <Map<String, String>>[];

    // 1. System Prompt
    messages.add({
      'role': 'system',
      'content': systemInstruction,
    });

    // 2. Riwayat Percakapan (beberapa pesan terakhir agar hemat token)
    for (final history in conversationHistory.take(6)) {
      messages.add({
        'role': history['role'] ?? 'user',
        'content': history['content'] ?? '',
      });
    }

    // 3. Pesan Pengguna Saat Ini (konten selalu berupa String agar kompatibel penuh)
    final userContent = StringBuffer();

    if (documentText != null && documentText.trim().isNotEmpty) {
      userContent.writeln(
        'Berikut adalah isi berkas dokumen CV / Resume saya:\n'
        '--- AWAL DOKUMEN CV ---\n'
        '$documentText\n'
        '--- AKHIR DOKUMEN CV ---\n',
      );
    } else if (base64Image != null && base64Image.isNotEmpty) {
      userContent.writeln(
        '[Foto berkas CV/Resume terlampir]\n',
      );
    }

    if (userPrompt.trim().isNotEmpty) {
      userContent.writeln(userPrompt);
    } else if (documentText != null || base64Image != null) {
      userContent.writeln(
        'Tolong analisis CV di atas dan rekomendasikan lowongan pekerjaan yang cocok dari daftar lowongan terbuka.',
      );
    }

    messages.add({
      'role': 'user',
      'content': userContent.toString(),
    });

    // Coba request dengan model utama, lalu fallback jika terjadi kendala model
    try {
      return await _executeRequest(apiKey, GroqConfig.textModel, messages);
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if ((errStr.contains('does not exist') ||
              errStr.contains('not have access') ||
              errStr.contains('404')) &&
          GroqConfig.fallbackTextModel != GroqConfig.textModel) {
        debugPrint(
          '⚠️ Model ${GroqConfig.textModel} gagal, mencoba fallback ke ${GroqConfig.fallbackTextModel}...',
        );
        return await _executeRequest(
          apiKey,
          GroqConfig.fallbackTextModel,
          messages,
        );
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _executeRequest(
    String apiKey,
    String model,
    List<Map<String, String>> messages,
  ) async {
    final bodyPayload = {
      'model': model,
      'messages': messages,
      'temperature': 0.6,
      'max_tokens': 1500,
    };

    debugPrint('🤖 [GROQ API] Mengirim request dengan model: $model');

    http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(GroqConfig.apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(bodyPayload),
          )
          .timeout(const Duration(seconds: 40));
    } catch (e) {
      debugPrint('💥 [GROQ ERROR] Koneksi gagal: $e');
      throw Exception(
        'Gagal terhubung ke server AI Groq. Periksa koneksi internet Anda atau coba sesaat lagi.',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      final replyText =
          json['choices']?[0]?['message']?['content']?.toString() ?? '';

      // Ekstrak ID pekerjaan rekomendasi dari tag [RECOMMENDED_JOBS: 1, 2]
      final recommendedIds = _extractJobIds(replyText);
      final cleanText = _cleanResponseText(replyText);

      return {
        'text': cleanText,
        'recommended_job_ids': recommendedIds,
        'raw': json,
      };
    }

    debugPrint(
      '❌ [GROQ STATUS ${response.statusCode}] Respons: ${response.body}',
    );
    try {
      final errorJson = jsonDecode(response.body);
      final errorMsg = errorJson['error']?['message']?.toString() ??
          'Terjadi kesalahan saat memproses permintaan ke Groq API.';

      if (response.statusCode == 401) {
        throw Exception(
          'API Key Groq di file .env tidak valid atau sudah kedaluwarsa. Periksa kembali nilai GROQ_API_KEY di file .env.',
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          'Batas kuota harian/menit Groq tercapai. Silakan tunggu sebentar dan coba lagi.',
        );
      }

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(
        'Gagal memproses respon dari AI Groq (Kode: ${response.statusCode}).',
      );
    }
  }

  /// Membuat system prompt dengan daftar lowongan terbuka Luang.In
  String _buildSystemInstruction({
    required List<HomeModel> availableJobs,
    String? userLocationName,
    double? userLatitude,
    double? userLongitude,
  }) {
    final jobBuffer = StringBuffer();

    if (availableJobs.isEmpty) {
      jobBuffer.writeln(
        'Saat ini belum ada data lowongan aktif yang dimuat dari server.',
      );
    } else {
      for (final job in availableJobs) {
        String distanceStr = '';
        if (userLatitude != null &&
            userLongitude != null &&
            job.latitude != 0 &&
            job.longitude != 0) {
          final meters = Geolocator.distanceBetween(
            userLatitude,
            userLongitude,
            job.latitude,
            job.longitude,
          );
          final km = meters / 1000.0;
          if (km <= 10.0) {
            distanceStr =
                ' | Jarak: ${km.toStringAsFixed(1)} km (DALAM RADIUS 10 KM)';
          } else {
            distanceStr = ' | Jarak: ${km.toStringAsFixed(1)} km';
          }
        }

        jobBuffer.writeln(
          '- ID: ${job.id} | Judul: ${job.judul} | PT/Usaha: ${job.namaPt} | '
          'Upah: ${job.upah} | Durasi: ${job.durasi}$distanceStr | Deskripsi: ${job.deskripsi}',
        );
      }
    }

    final lokasiInfo = userLocationName != null && userLocationName.isNotEmpty
        ? 'Lokasi pengguna saat ini: $userLocationName.'
        : 'Lokasi pengguna: Belum terdeteksi atau di sekitar area aktif.';

    return '''
Anda adalah Asisten Cerdas Luang.In, asisten resmi untuk aplikasi bursa kerja harian dan paruh waktu di Indonesia.

$lokasiInfo

ATURAN UTAMA GAYA KOMUNIKASI (SANGAT PENTING):
1. JAWAB DENGAN SANGAT SINGKAT, PADAT, DAN LANGSUNG KE INTINYA! (Maksimal total 3 sampai 5 kalimat). Pengguna malas membaca teks yang panjang dan bertele-tele.
2. DILARANG KERAS MEMBUAT TABEL MARKDOWN (DILARANG menggunakan format '| ... |'). Lowongan pekerjaan sudah otomatis muncul di kartu visual aplikasi di bawah chat, jadi jangan pernah membuat tabel atau daftar lowongan panjang dalam teks.
3. DILARANG KERAS MENGGUNAKAN SIMBOL BINTANG / ASTERISK (*** atau ** atau *). Jangan menebalkan teks dengan tanda bintang. Gunakan teks polos yang bersih.
4. JANGAN gunakan tanda pagar Markdown (seperti ### atau ##).
5. WAJIB 100% BAHASA INDONESIA YANG RAMAH, SOPAN, DAN SUPORTIF. Dilarang bahasa Inggris.

ATURAN VALIDASI DOKUMEN / CV:
Periksa teks berkas atau lampiran yang dikirimkan oleh pengguna:
• JIKA DOKUMEN TERSEBUT BUKAN CV / RESUME KERJA (misalnya berupa laporan kuliah, materi perkuliahan, tugas/makalah, modul belajar, faktur/kuitansi, atau dokumen acak yang bukan riwayat profil pencari kerja):
  - Jelaskan dengan kalimat yang ramah dan sopan bahwa berkas yang diunggah tampaknya bukan merupakan dokumen CV (Curriculum Vitae) atau resume kerja.
  - Sarankan pengguna untuk mengunggah dokumen CV asli agar keahliannya dapat dianalisis dengan akurat.
  - Namun demikian, untuk tetap membantu, beritahukan bahwa Anda telah menampilkan pilihan lowongan kerja terbuka terdekat (dalam radius 10 km / lowongan terdekat) pada kartu rekomendasi di bawah ini!
• JIKA DOKUMEN ADALAH CV / RESUME KERJA YANG SAH:
  - Sebutkan 1 kalimat ringkas mengenai keahlian utama pengguna.
  - Cocokkan dengan lowongan di Luang.In, PRIORITASKAN lowongan yang berada DALAM RADIUS 10 KM dari pengguna.
  - Jika ada yang cocok, sebutkan singkat dan arahkan untuk melihat kartu lowongan di bawah.
  - Jika belum ada yang cocok persis, sampaikan dengan sopan bahwa posisi yang persis sama belum ada, tetapi sarankan untuk mengecek alternatif lowongan terdekat yang sedang aktif pada kartu di bawah.

DAFTAR LOWONGAN PEKERJAAN TERBUKA DI LUANG.IN:
$jobBuffer

KETENTUAN WAJIB TAG REKOMENDASI DI AKHIR BALASAN:
Di baris paling akhir balasan Anda, Anda WAJIB mencantumkan tag:
[RECOMMENDED_JOBS: id1, id2, id3, id4, id5]

Ketentuan Tag:
• WAJIB MENAMPILKAN TEPAT 5 ID LOWONGAN!
• Utamakan ID lowongan yang berada DALAM RADIUS 10 KM dan cocok dengan minat/keahlian pengguna.
• Jika tidak ada yang cocok atau dokumen bukan CV, TETAP masukkan 5 ID lowongan aktif terdekat dari daftar di atas sebagai rekomendasi agar kartu tetap muncul di aplikasi.
• Hanya gunakan angka ID yang ada di daftar lowongan terbuka di atas.
''';
  }

  /// Ekstraksi ID pekerjaan dari tag khusus
  List<int> _extractJobIds(String text) {
    final regex = RegExp(
      r'\[(?:RECOMMENDED_JOBS|JOB_RECOMMENDATION):\s*([0-9,\s]+)\]',
      caseSensitive: false,
    );
    final match = regex.firstMatch(text);
    if (match != null) {
      final rawIds = match.group(1) ?? '';
      return rawIds
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return [];
  }

  /// Menghilangkan tag internal, simbol asterisk (***, **, *), tabel markdown, serta format yang tidak diinginkan
  String _cleanResponseText(String text) {
    var cleaned = text
        .replaceAll(
          RegExp(
            r'\[(?:RECOMMENDED_JOBS|JOB_RECOMMENDATION):\s*[0-9,\s]+\]',
            caseSensitive: false,
          ),
          '',
        );

    // Hapus baris tabel markdown (| Kolom | Kolom | dan |---|---|)
    cleaned = cleaned.replaceAll(
      RegExp(r'^\s*\|.*\|\s*$', multiLine: true),
      '',
    );

    // Hapus garis pemisah markdown (--- atau ___ atau ***)
    cleaned = cleaned.replaceAll(
      RegExp(r'^\s*[-_*]{3,}\s*$', multiLine: true),
      '',
    );

    // Hapus heading markdown (#, ##, ###)
    cleaned = cleaned.replaceAll(
      RegExp(r'^\s*#{1,6}\s*', multiLine: true),
      '',
    );

    // Hapus asterisk tiga, dua, atau satu (***, **, *)
    cleaned = cleaned.replaceAll('***', '');
    cleaned = cleaned.replaceAll('**', '');

    // Ubah bullet bertanda asterisk (* poin) menjadi bullet rapi (• poin)
    cleaned = cleaned.replaceAll(RegExp(r'^\s*[\*\-]\s+', multiLine: true), '• ');

    // Hapus sisa asterisk tunggal yang tersisa
    cleaned = cleaned.replaceAll('*', '');

    // Rapikan jeda baris berlebih
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return cleaned.trim();
  }
}
