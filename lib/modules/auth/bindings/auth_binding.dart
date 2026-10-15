import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/providers/auth_provider.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(
        StorageService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<ApiService>()) {
      Get.lazyPut<ApiService>(
        () => ApiService(Get.find<StorageService>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthProvider>()) {
      Get.lazyPut<AuthProvider>(
        () => AuthProvider(
          apiService: Get.find<ApiService>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(Get.find<AuthProvider>()),
      );
    }
  }
}