import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../core/services/storage_service.dart';

class SkillProfileProvider {
  final StorageService storageService;

  SkillProfileProvider(this.storageService);

  Future<Map<String, dynamic>> saveProfile({
    required String whatsapp,
    String? domisili,
    required String primaryRole,
    required List<String> skills,
    required String experience,
  }) async {
    final token = storageService.getToken();

    final response = await http.post(
      Uri.parse(ApiConfig.skillProfile),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'whatsapp': whatsapp,
        'domisili': domisili,
        'primary_role': primaryRole,
        'skills': skills,
        'experience': experience,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['message'] ?? 'Gagal menyimpan profil keahlian.',
    );
  }
}