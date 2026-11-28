import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:luang_in/core/services/storage_service.dart';
import 'package:luang_in/data/models/home_model.dart';

class SavedJobsService extends GetxService {
  final GetStorage _storage = GetStorage();
  final RxList<HomeModel> savedJobs = <HomeModel>[].obs;

  String _activeKey = '';

  @override
  void onInit() {
    super.onInit();
    syncUserSavedJobs();
  }

  String _getStorageKey() {
    try {
      if (Get.isRegistered<StorageService>()) {
        final user = Get.find<StorageService>().getUser();
        if (user != null) {
          final id = user['id']?.toString().trim();
          final email = user['email']?.toString().trim().toLowerCase();
          if (id != null && id.isNotEmpty && id != '0' && id != 'null') {
            return 'saved_jobs_user_id_$id';
          }
          if (email != null && email.isNotEmpty && email != 'null') {
            final cleanEmail = email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
            return 'saved_jobs_user_email_$cleanEmail';
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ [SAVED JOBS] Gagal membaca key user: $e');
    }
    return 'saved_jobs_guest';
  }

  void syncUserSavedJobs() {
    final key = _getStorageKey();
    if (_activeKey != key) {
      _activeKey = key;
      _loadFromStorage();
    }
  }

  void clearOnLogout() {
    _activeKey = '';
    savedJobs.clear();
  }

  void _loadFromStorage() {
    try {
      final key = _getStorageKey();
      _activeKey = key;
      final dynamic raw = _storage.read(key);
      if (raw is List) {
        final loaded = raw
            .whereType<Map>()
            .map((e) => HomeModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        savedJobs.assignAll(loaded);
      } else {
        savedJobs.clear();
      }
    } catch (e) {
      debugPrint('⚠️ [SAVED JOBS] Gagal memuat data tersimpan: $e');
      savedJobs.clear();
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final key = _getStorageKey();
      _activeKey = key;
      await _storage.write(
        key,
        savedJobs.map((job) => job.toJson()).toList(),
      );
    } catch (e) {
      debugPrint('⚠️ [SAVED JOBS] Gagal menyimpan data: $e');
    }
  }

  bool isSaved(int jobId) {
    syncUserSavedJobs();
    return savedJobs.any((j) => j.id == jobId);
  }

  Future<bool> toggleSave(HomeModel job) async {
    syncUserSavedJobs();
    final idx = savedJobs.indexWhere((j) => j.id == job.id);
    bool nowSaved;
    if (idx != -1) {
      savedJobs.removeAt(idx);
      nowSaved = false;
    } else {
      savedJobs.insert(0, job);
      nowSaved = true;
    }
    await _saveToStorage();
    return nowSaved;
  }

  Future<void> removeJob(int jobId) async {
    syncUserSavedJobs();
    savedJobs.removeWhere((j) => j.id == jobId);
    await _saveToStorage();
  }
}
