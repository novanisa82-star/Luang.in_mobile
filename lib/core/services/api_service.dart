import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class ApiService extends GetxService {
  final StorageService storageService;

  ApiService(this.storageService);

  Future<http.Response> _safeRequest(
    String method,
    String url,
    Future<http.Response> Function() request,
  ) async {
    debugPrint('🌐 [HTTP $method] Mengirim request ke: $url');
    try {
      final response = await request().timeout(const Duration(seconds: 15));
      debugPrint('📡 [HTTP $method RESPONSE]');
      debugPrint('   URL: $url');
      debugPrint('   Status Code: ${response.statusCode}');
      debugPrint('   Response Body: ${response.body}');
      return response;
    } on http.ClientException catch (e) {
      debugPrint('💥 [CLIENT EXCEPTION / CONNECTION REFUSED] Gagal konek ke $url: $e');
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan server aktif dan periksa koneksi internet Anda.',
      );
    } on TimeoutException catch (e) {
      debugPrint('⏳ [TIMEOUT EXCEPTION] Waktu habis untuk request ke $url: $e');
      throw Exception('Waktu koneksi habis. Silakan coba beberapa saat lagi.');
    } catch (e, stack) {
      debugPrint('⚠️ [HTTP ERROR] Gagal menghubungi $url: $e');
      debugPrint('   Stack: $stack');
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan server aktif dan periksa koneksi internet Anda.',
      );
    }
  }

  Future<Map<String, dynamic>> get(String url) async {
    final response = await _safeRequest(
      'GET',
      url,
      () async => http.get(Uri.parse(url), headers: await _headers()),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    debugPrint('📦 [POST PAYLOAD] ${jsonEncode(body)}');
    final response = await _safeRequest(
      'POST',
      url,
      () async => http.post(
        Uri.parse(url),
        headers: await _headers(),
        body: jsonEncode(body),
      ),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAuthenticated(String url) async {
    final response = await _safeRequest(
      'GET (AUTH)',
      url,
      () async => http.get(
        Uri.parse(url),
        headers: await _headers(authenticated: true),
      ),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> postAuthenticated(
    String url, {
    required Map<String, dynamic> data,
  }) async {
    debugPrint('📦 [POST AUTH PAYLOAD] ${jsonEncode(data)}');
    final response = await _safeRequest(
      'POST (AUTH)',
      url,
      () async => http.post(
        Uri.parse(url),
        headers: await _headers(authenticated: true),
        body: jsonEncode(data),
      ),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> putAuthenticated(
    String url, {
    required Map<String, dynamic> data,
  }) async {
    debugPrint('📦 [PUT AUTH PAYLOAD] ${jsonEncode(data)}');
    final response = await _safeRequest(
      'PUT (AUTH)',
      url,
      () async => http.put(
        Uri.parse(url),
        headers: await _headers(authenticated: true),
        body: jsonEncode(data),
      ),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadFile(
    String url, {
    required String filePath,
    required String fieldName,
  }) async {
    final token = storageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login tidak ditemukan. Silakan login kembali.');
    }

    debugPrint('📤 [UPLOAD FILE] Mengirim $filePath ke $url ($fieldName)');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📡 [UPLOAD RESPONSE] Status: ${response.statusCode}');
      debugPrint('   Body: ${response.body}');

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      debugPrint('💥 [UPLOAD CLIENT EXCEPTION] $e');
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan server aktif dan periksa koneksi Anda.',
      );
    } on TimeoutException catch (e) {
      debugPrint('⏳ [UPLOAD TIMEOUT] $e');
      throw Exception('Waktu pengunggahan habis. Silakan coba kembali.');
    } catch (e) {
      debugPrint('⚠️ [UPLOAD UNKNOWN ERROR] $e');
      throw Exception('Gagal mengunggah berkas. Silakan coba kembali.');
    }
  }

  Future<Map<String, dynamic>> postMultipartAuthenticated(
    String url, {
    Map<String, String> fields = const {},
    String? filePath,
    String fileFieldName = 'cv',
  }) async {
    final token = storageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login tidak ditemukan. Silakan login kembali.');
    }

    debugPrint('📤 [MULTIPART POST] Mengirim ke $url');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll(fields);

      if (filePath != null && filePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(fileFieldName, filePath),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📡 [MULTIPART RESPONSE] Status: ${response.statusCode}');
      debugPrint('   Body: ${response.body}');

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      debugPrint('💥 [MULTIPART CLIENT EXCEPTION] $e');
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan server aktif dan periksa koneksi Anda.',
      );
    } on TimeoutException catch (e) {
      debugPrint('⏳ [MULTIPART TIMEOUT] $e');
      throw Exception('Waktu pengiriman habis. Silakan coba kembali.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mengirim data. Silakan coba kembali.');
    }
  }

  Future<Map<String, String>> _headers({bool authenticated = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final token = storageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Sesi login tidak ditemukan. Silakan login kembali.');
      }

      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }

      data = decoded;
    } catch (_) {
      debugPrint('⚠️ [JSON DECODE FAILED] Respons server bukan JSON: ${response.body}');
      if (response.statusCode >= 500) {
        throw Exception('Layanan server sedang mengalami kendala sementara.');
      } else if (response.statusCode == 404) {
        throw Exception('Layanan yang diminta tidak ditemukan.');
      } else {
        throw Exception('Terjadi kesalahan pada respon server.');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final errors = data['errors'];
    String message = data['message']?.toString() ?? 'Terjadi kesalahan';

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        message = firstError.first.toString();
      }
    }

    debugPrint('❌ [API STATUS ${response.statusCode}] Pesan error: $message');
    if (errors != null) {
      debugPrint('   Errors detail: $errors');
    }

    // Saring pesan error agar tidak menampilkan rute, localhost, URL, atau query database ke user
    final lower = message.toLowerCase();
    if (lower.contains('http') ||
        lower.contains('localhost') ||
        lower.contains('127.0.0.1') ||
        lower.contains('192.168.') ||
        lower.contains('/api/') ||
        lower.contains('route') ||
        lower.contains('uri=') ||
        lower.contains('sql') ||
        lower.contains('database') ||
        lower.contains('table') ||
        lower.contains('column') ||
        lower.contains('exception') ||
        message.contains('/') ||
        message.contains('\\')) {
      message = 'Terjadi kendala saat memproses data di server.';
    }

    throw Exception(message);
  }
}
