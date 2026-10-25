
import 'package:get/get.dart';

import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/core/config/api_config.dart';
import '../models/riwayat_model.dart';

class RiwayatService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<RiwayatModel>> getRiwayatLamaran() async {
    final response = await _apiService.getAuthenticated(
      '${ApiConfig.baseUrl}/mobile/riwayat-lamaran',
    );

    final data = response['data'];

    if (data is! List) {
      throw Exception('Format data riwayat dari server tidak valid.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(RiwayatModel.fromJson)
        .toList();
  }
}