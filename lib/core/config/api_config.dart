import 'package:flutter/foundation.dart';

class ApiConfig {
  // IP laptop saat terhubung ke Wi-Fi / Hotspot untuk testing di HP fisik
  static const String _lanIp = '192.168.1.3';

  // Otomatis memilih host:
  // - Jika dijalankan di browser (Chrome / Flutter Web), gunakan 127.0.0.1
  // - Jika di HP fisik Android / Emulator, gunakan IP LAN
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }
    return 'http://$_lanIp:8000/api';
  }

  static String get register => '$baseUrl/mobile/register';
  static String get login => '$baseUrl/mobile/login';
  static String get me => '$baseUrl/mobile/me';
  static String get logout => '$baseUrl/mobile/logout';
  static String get skillProfile => '$baseUrl/mobile/skill-profile';
  static String get completeRegistration => '$baseUrl/mobile/complete-registration';
  static String pekerjaanDetail(int id) => '$baseUrl/mobile/pekerjaan/$id';
  static String lamarPekerjaan(int id) => '$baseUrl/mobile/pekerjaan/$id/lamar';
}
