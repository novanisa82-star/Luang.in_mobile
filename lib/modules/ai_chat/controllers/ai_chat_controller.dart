import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luang_in/core/config/api_config.dart';
import 'package:luang_in/core/services/api_service.dart';
import 'package:luang_in/core/services/groq_service.dart';
import 'package:luang_in/core/services/storage_service.dart';
import 'package:luang_in/data/models/home_model.dart';
import 'package:luang_in/modules/home/controllers/home_controller.dart';
import 'package:luang_in/modules/home/controllers/location_controller.dart';
import 'package:luang_in/utils/app_snackbar.dart';
import 'package:luang_in/utils/document_helper.dart';
import '../models/ai_message_model.dart';

class AiChatController extends GetxController {
  final GroqService _groqService = GroqService();
  final ImagePicker _imagePicker = ImagePicker();
  final GetStorage _storage = GetStorage();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<AiMessage> messages = <AiMessage>[].obs;
  final RxBool isGenerating = false.obs;

  // Status Lokasi Pengguna
  final Rxn<Position> userPosition = Rxn<Position>();
  final RxString userLocationName = 'Mendeteksi lokasi...'.obs;
  final RxBool isDetectingLocation = false.obs;

  // Status Lampiran Terpilih
  final RxnString selectedAttachmentPath = RxnString();
  final RxnString selectedAttachmentName = RxnString();
  final RxnInt selectedAttachmentSize = RxnInt();
  final Rx<ChatAttachmentType> selectedAttachmentType =
      ChatAttachmentType.none.obs;

  // Daftar Lowongan Terbuka untuk Dicocokkan
  final RxList<HomeModel> availableJobs = <HomeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _loadAvailableJobs();
    detectLocation();
  }

  /// Mendapatkan Key Storage unik per ID User
  String _getStorageKey() {
    try {
      if (Get.isRegistered<StorageService>()) {
        final storageService = Get.find<StorageService>();
        final user = storageService.getUser();
        if (user != null && user['id'] != null) {
          return 'ai_chat_history_user_${user['id']}';
        }
      }
    } catch (e) {
      debugPrint('⚠️ [AI CHAT] Gagal mengambil user id untuk storage: $e');
    }
    return 'ai_chat_history_guest';
  }

  /// Memuat riwayat percakapan dari GetStorage
  void _loadChatHistory() {
    try {
      final key = _getStorageKey();
      final dynamic raw = _storage.read(key);
      if (raw is List && raw.isNotEmpty) {
        final List<AiMessage> loaded = [];
        for (final item in raw) {
          if (item is Map) {
            loaded.add(AiMessage.fromJson(Map<String, dynamic>.from(item)));
          }
        }
        if (loaded.isNotEmpty) {
          messages.assignAll(loaded);
          return;
        }
      }
    } catch (e) {
      debugPrint('⚠️ [AI CHAT] Gagal memuat riwayat chat dari storage: $e');
    }

    _initWelcomeMessage();
  }

  /// Menyimpan riwayat percakapan ke GetStorage
  Future<void> _saveChatHistory() async {
    try {
      final key = _getStorageKey();
      final toSave = messages
          .where((m) => !m.isLoading)
          .map((m) => m.toJson())
          .toList();
      await _storage.write(key, toSave);
    } catch (e) {
      debugPrint('⚠️ [AI CHAT] Gagal menyimpan riwayat chat ke storage: $e');
    }
  }

  /// Menghapus seluruh riwayat chat untuk user ini
  Future<void> clearChatHistory() async {
    try {
      final key = _getStorageKey();
      await _storage.remove(key);
      messages.clear();
      _initWelcomeMessage();
      AppSnackbar.success(
        'Riwayat Direset',
        'Percakapan AI Chat telah dibersihkan.',
      );
    } catch (e) {
      debugPrint('⚠️ [AI CHAT] Gagal membersihkan riwayat chat: $e');
    }
  }

  /// Mendeteksi lokasi terkini pengguna
  Future<void> detectLocation() async {
    try {
      isDetectingLocation.value = true;

      // Cek apakah LocationController di modul Home sudah ada
      if (Get.isRegistered<LocationController>()) {
        final locCtrl = Get.find<LocationController>();
        if (locCtrl.locationName.value.isNotEmpty &&
            !locCtrl.locationName.value.contains('Mendeteksi')) {
          userLocationName.value = locCtrl.locationName.value;
        }
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userLocationName.value = 'Layanan lokasi nonaktif';
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        userLocationName.value = 'Izin lokasi belum diberikan';
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      userPosition.value = pos;

      final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (places.isNotEmpty) {
        final place = places.first;
        userLocationName.value = place.subAdministrativeArea?.isNotEmpty == true
            ? place.subAdministrativeArea!
            : place.locality?.isNotEmpty == true
                ? place.locality!
                : place.administrativeArea ?? 'Lokasi saat ini';
      } else {
        userLocationName.value = 'Lokasi ditemukan';
      }
    } catch (e) {
      debugPrint('⚠️ [AI CHAT] Gagal mendeteksi lokasi: $e');
      if (userLocationName.value == 'Mendeteksi lokasi...') {
        userLocationName.value = 'Lokasi saat ini';
      }
    } finally {
      isDetectingLocation.value = false;
    }
  }

  /// Menghitung jarak lowongan dari posisi user (dalam km)
  double getJobDistanceKm(HomeModel job) {
    if (userPosition.value == null || (job.latitude == 0 && job.longitude == 0)) {
      return -1.0;
    }
    final meters = Geolocator.distanceBetween(
      userPosition.value!.latitude,
      userPosition.value!.longitude,
      job.latitude,
      job.longitude,
    );
    return meters / 1000.0;
  }

  /// Apakah lowongan berada dalam radius 10 km
  bool isWithin10Km(HomeModel job) {
    final dist = getJobDistanceKm(job);
    return dist >= 0 && dist <= 10.0;
  }

  Future<void> _loadAvailableJobs() async {
    try {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        if (homeController.pekerjaanList.isNotEmpty) {
          availableJobs.assignAll(homeController.pekerjaanList);
          return;
        }
      }

      if (Get.isRegistered<ApiService>()) {
        final apiService = Get.find<ApiService>();
        final response = await apiService.getAuthenticated(
          '${ApiConfig.baseUrl}/mobile/pekerjaan',
        );
        final data = response['data'];
        if (data is List) {
          availableJobs.assignAll(
            data.whereType<Map<String, dynamic>>().map(HomeModel.fromJson),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ [AI CHAT] Gagal memuat lowongan: $e');
    }
  }

  void _initWelcomeMessage() {
    if (messages.isEmpty) {
      messages.add(
        AiMessage(
          id: 'welcome_1',
          isUser: false,
          text:
              'Halo! Saya Asisten AI Luang.In 🤖✨\n\n'
              'Saya siap membantu Anda mencocokkan keahlian dengan lowongan kerja luang di sekitar Anda (radius 10 km).\n\n'
              '💡 Cara Penggunaan:\n'
              '• Ketuk tombol klip kertas (📎) untuk melampirkan Dokumen CV (PDF/Word) atau Foto CV.\n'
              '• Jika bukan berkas CV, kami tetap akan membantu menampilkan lowongan kerja terbuka terdekat.',
        ),
      );
    }
  }

  /// Memilih foto dari Galeri
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (file != null) {
        final length = await file.length();
        selectedAttachmentPath.value = file.path;
        selectedAttachmentName.value = file.name;
        selectedAttachmentSize.value = length;
        selectedAttachmentType.value = ChatAttachmentType.image;
      }
    } catch (e) {
      AppSnackbar.error(
        'Gagal Membuka Galeri',
        'Tidak dapat mengakses galeri foto: $e',
      );
    }
  }

  /// Mengambil foto langsung dengan Kamera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (file != null) {
        final length = await file.length();
        selectedAttachmentPath.value = file.path;
        selectedAttachmentName.value = file.name;
        selectedAttachmentSize.value = length;
        selectedAttachmentType.value = ChatAttachmentType.image;
      }
    } catch (e) {
      AppSnackbar.error(
        'Gagal Membuka Kamera',
        'Tidak dapat mengakses kamera: $e',
      );
    }
  }

  /// Memilih berkas dokumen (PDF, TXT, DOCX, DOC)
  Future<void> pickDocument() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'doc', 'docx', 'rtf'],
      );

      if (files.isNotEmpty) {
        final file = files.first;
        if (file.path != null) {
          final fileSize = file.lengthSync() ?? (await file.length());
          selectedAttachmentPath.value = file.path;
          selectedAttachmentName.value = file.name;
          selectedAttachmentSize.value = fileSize;
          selectedAttachmentType.value = ChatAttachmentType.document;
        }
      }
    } catch (e) {
      AppSnackbar.error(
        'Gagal Memilih Dokumen',
        'Terjadi kendala saat memilih dokumen: $e',
      );
    }
  }

  /// Menghapus lampiran yang sedang dipilih
  void clearAttachment() {
    selectedAttachmentPath.value = null;
    selectedAttachmentName.value = null;
    selectedAttachmentSize.value = null;
    selectedAttachmentType.value = ChatAttachmentType.none;
  }

  /// Mengirim pesan dan memproses analisis CV
  Future<void> sendMessage([String? quickPrompt]) async {
    final text = quickPrompt ?? textController.text.trim();
    final hasAttachment =
        selectedAttachmentType.value != ChatAttachmentType.none &&
        selectedAttachmentPath.value != null;

    if (text.isEmpty && !hasAttachment) return;

    if (isGenerating.value) return;

    // Ambil data lampiran
    final attachmentPath = selectedAttachmentPath.value;
    final attachmentName = selectedAttachmentName.value;
    final attachmentSize = selectedAttachmentSize.value;
    final attachmentType = selectedAttachmentType.value;

    // Bersihkan input
    textController.clear();
    clearAttachment();

    // Tambah pesan user
    final userMessage = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isUser: true,
      text: text,
      attachmentPath: attachmentPath,
      attachmentName: attachmentName,
      attachmentSize: attachmentSize,
      attachmentType: attachmentType,
    );

    messages.add(userMessage);
    await _saveChatHistory();

    // Tambah bubble loading AI
    final aiLoadingId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    messages.add(
      AiMessage(
        id: aiLoadingId,
        isUser: false,
        text: 'Sedang membaca dan menganalisis...',
        isLoading: true,
      ),
    );

    isGenerating.value = true;
    _scrollToBottom();

    try {
      String? base64Image;
      String? mimeType;
      String? documentText;

      // Persiapan data lampiran
      if (attachmentPath != null) {
        final file = File(attachmentPath);

        if (attachmentType == ChatAttachmentType.image) {
          final bytes = await file.readAsBytes();
          base64Image = base64Encode(bytes);
          final ext = attachmentName?.split('.').last.toLowerCase() ?? 'jpeg';
          mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
        } else if (attachmentType == ChatAttachmentType.document) {
          documentText = await DocumentHelper.extractTextFromFile(file);
        }
      }

      // Siapkan riwayat percakapan untuk konteks Groq
      final history = <Map<String, String>>[];
      for (final msg in messages.take(messages.length - 2)) {
        if (!msg.isLoading) {
          history.add({
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.text,
          });
        }
      }

      // Pastikan data lowongan segar
      if (availableJobs.isEmpty) {
        await _loadAvailableJobs();
      }

      // Urutkan lowongan yang dikirim ke AI: prioritaskan lowongan dalam radius 10 km
      final sortedJobs = List<HomeModel>.from(availableJobs);
      sortedJobs.sort((a, b) {
        final distA = getJobDistanceKm(a);
        final distB = getJobDistanceKm(b);
        if (distA >= 0 && distB >= 0) {
          return distA.compareTo(distB);
        } else if (distA >= 0) {
          return -1;
        } else if (distB >= 0) {
          return 1;
        }
        return 0;
      });

      // Kirim ke Groq API
      final result = await _groqService.sendRequest(
        userPrompt: text,
        base64Image: base64Image,
        imageMimeType: mimeType,
        documentText: documentText,
        conversationHistory: history,
        availableJobs: sortedJobs,
        userLocationName: userLocationName.value,
        userLatitude: userPosition.value?.latitude,
        userLongitude: userPosition.value?.longitude,
      );

      final replyText = result['text'] as String? ?? 'Maaf, tidak ada respon.';
      final rawRecommendedJobIds =
          result['recommended_job_ids'] as List<int>? ?? [];

      // Pastikan selalu ada 5 rekomendasi lowongan pekerjaan yang ditampilkan
      final List<int> finalJobIds = List<int>.from(rawRecommendedJobIds);
      if (sortedJobs.isNotEmpty) {
        for (final job in sortedJobs) {
          if (finalJobIds.length >= 5) break;
          if (!finalJobIds.contains(job.id)) {
            finalJobIds.add(job.id);
          }
        }
      }

      // Perbarui pesan AI dengan hasil respon
      final index = messages.indexWhere((m) => m.id == aiLoadingId);
      if (index != -1) {
        messages[index] = AiMessage(
          id: aiLoadingId,
          isUser: false,
          text: replyText,
          recommendedJobIds: finalJobIds,
          isLoading: false,
        );
      }

      // Simpan percakapan setelah AI merespon
      await _saveChatHistory();
    } catch (e) {
      final index = messages.indexWhere((m) => m.id == aiLoadingId);
      final errorText = e.toString().replaceFirst('Exception: ', '');

      if (index != -1) {
        messages[index] = AiMessage(
          id: aiLoadingId,
          isUser: false,
          text: '❌ Terjadi kendala:\n\n$errorText',
          isLoading: false,
        );
      }
      await _saveChatHistory();
    } finally {
      isGenerating.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
