import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  /// Ubah error teknis / sistem / URL / rute menjadi pesan bahasa Indonesia yang ramah dan mudah dipahami user
  static String formatErrorMessage(dynamic error, {String? defaultMessage}) {
    if (error == null) {
      return defaultMessage ?? 'Terjadi kendala pada sistem. Silakan coba kembali.';
    }

    String raw = error.toString().replaceFirst('Exception: ', '').trim();

    final lower = raw.toLowerCase();

    // Deteksi jika mengandung rute, URL, localhost, IP, endpoint, atau jejak teknis jaringan
    if (lower.contains('http://') ||
        lower.contains('https://') ||
        lower.contains('localhost') ||
        lower.contains('127.0.0.1') ||
        lower.contains('192.168.') ||
        lower.contains('/api/') ||
        lower.contains('route') ||
        lower.contains('uri=') ||
        lower.contains('uri =') ||
        lower.contains('endpoint') ||
        lower.contains('address =') ||
        lower.contains('port =') ||
        lower.contains('errno') ||
        lower.contains('os error') ||
        lower.contains('post ') ||
        lower.contains('get ') ||
        lower.contains('xmlhttprequest') ||
        lower.contains('handshake') ||
        lower.contains('certificate')) {
      return defaultMessage ??
          'Tidak dapat terhubung ke server. Pastikan koneksi internet Anda aktif atau coba beberapa saat lagi.';
    }

    // Kendala jaringan / koneksi server
    if (lower.contains('socketexception') ||
        lower.contains('connection refused') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('clientexception') ||
        lower.contains('no internet')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda atau pastikan server sedang aktif.';
    }

    if (lower.contains('timeoutexception') || lower.contains('timed out')) {
      return 'Waktu koneksi habis. Silakan periksa jaringan internet Anda dan coba lagi.';
    }

    // Database / SQL / Server error internal
    if (lower.contains('sql') ||
        lower.contains('database') ||
        lower.contains('syntax error') ||
        lower.contains('column') ||
        lower.contains('table') ||
        lower.contains('stack trace') ||
        lower.contains('respons server tidak valid') ||
        lower.contains('500') ||
        lower.contains('502') ||
        lower.contains('503') ||
        lower.contains('internal server error')) {
      return 'Layanan sedang mengalami gangguan sementara. Silakan coba beberapa saat lagi.';
    }

    if (lower.contains('404') || lower.contains('not found')) {
      return 'Layanan atau data yang diminta tidak ditemukan.';
    }

    // Validasi akun / autentikasi
    if (lower.contains('credentials do not match') ||
        lower.contains('email atau kata sandi') ||
        lower.contains('password salah') ||
        lower.contains('unauthorized') ||
        lower.contains('invalid credentials')) {
      return 'Email atau kata sandi yang Anda masukkan tidak sesuai.';
    }

    if (lower.contains('already been taken') || lower.contains('sudah terdaftar')) {
      return 'Email ini sudah terdaftar. Silakan gunakan email lain atau langsung masuk ke akun Anda.';
    }

    if (lower.contains('unauthenticated') || lower.contains('sesi login tidak ditemukan')) {
      return 'Sesi login Anda telah berakhir. Silakan masuk kembali.';
    }

    if (lower.contains('password confirmation does not match') ||
        lower.contains('konfirmasi password tidak sama')) {
      return 'Konfirmasi kata sandi tidak cocok. Harap periksa kembali.';
    }

    if (lower.contains('email format') || lower.contains('valid email')) {
      return 'Format alamat email tidak valid.';
    }

    if (lower.contains('password minimal 8') || lower.contains('at least 8')) {
      return 'Kata sandi minimal harus terdiri dari 8 karakter.';
    }

    // Jangan tampilkan pesan yang mengandung slash path seperti rute internal
    if (raw.contains('/') || raw.contains('\\') || raw.contains('::')) {
      return defaultMessage ??
          'Terjadi kendala saat menghubungi server. Silakan coba kembali.';
    }

    // Jika pesan sudah berupa teks biasa yang bersih dan wajar
    if (raw.isNotEmpty && !raw.contains('Exception') && !raw.contains('{') && raw.length < 120) {
      return raw;
    }

    return defaultMessage ?? 'Terjadi kendala. Silakan coba beberapa saat lagi.';
  }

  /// Snackbar Sukses (Hijau lembut)
  static void success(String title, String message) {
    _show(
      title: title.isEmpty ? 'Berhasil' : title,
      message: message,
      backgroundColor: const Color(0xFFF0FDF4),
      borderColor: const Color(0xFF86EFAC),
      textColor: const Color(0xFF14532D),
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Color(0xFF16A34A),
        size: 24,
      ),
    );
  }

  /// Snackbar Gagal / Error (Merah lembut)
  static void error(String title, String message) {
    _show(
      title: title.isEmpty ? 'Terjadi Kendala' : title,
      message: message,
      backgroundColor: const Color(0xFFFEF2F2),
      borderColor: const Color(0xFFFCA5A5),
      textColor: const Color(0xFF7F1D1D),
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Color(0xFFDC2626),
        size: 24,
      ),
    );
  }

  /// Helper cepat untuk menampilkan pesan error teknis yang otomatis disaring & diformat
  static void showError(
    dynamic error, {
    String title = 'Terjadi Kendala',
    String? defaultMessage,
  }) {
    final cleanMsg = formatErrorMessage(error, defaultMessage: defaultMessage);
    AppSnackbar.error(title, cleanMsg);
  }

  /// Snackbar Peringatan / Validasi (Kuning / Oranye lembut)
  static void warning(String title, String message) {
    _show(
      title: title.isEmpty ? 'Perhatian' : title,
      message: message,
      backgroundColor: const Color(0xFFFFFBEB),
      borderColor: const Color(0xFFFDE68A),
      textColor: const Color(0xFF78350F),
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Color(0xFFD97706),
        size: 24,
      ),
    );
  }

  /// Snackbar Informasi (Ungu / Indigo lembut senada tema aplikasi)
  static void info(String title, String message) {
    _show(
      title: title.isEmpty ? 'Informasi' : title,
      message: message,
      backgroundColor: const Color(0xFFF5EEFD),
      borderColor: const Color(0xFFDDD6FE),
      textColor: const Color(0xFF3B0764),
      icon: const Icon(
        Icons.info_outline_rounded,
        color: Color(0xFF7C3AED),
        size: 24,
      ),
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required Widget icon,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: icon,
      ),
      shouldIconPulse: false,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 16,
      borderWidth: 1,
      borderColor: borderColor,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: textColor.withOpacity(0.9),
          fontSize: 13,
          height: 1.35,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
