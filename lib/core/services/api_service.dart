import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class ApiService extends GetxService {
  final StorageService storageService;

  ApiService(this.storageService);

  Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAuthenticated(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(authenticated: true),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> postAuthenticated(String url) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(authenticated: true),
    );

    return _handleResponse(response);
  }

  Future<Map<String, String>> _headers({
    bool authenticated = false,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final token = storageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          'Sesi login tidak ditemukan. Silakan login kembali.',
        );
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
      throw Exception(
        'Respons server tidak valid (${response.statusCode}).',
      );
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

    throw Exception(message);
  }
}