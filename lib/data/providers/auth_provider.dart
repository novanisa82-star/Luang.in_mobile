import '../../core/config/api_config.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../models/user_model.dart';

class AuthProvider {
  final ApiService apiService;
  final StorageService storageService;

  AuthProvider({
    required this.apiService,
    required this.storageService,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? whatsapp,
    String? domisili,
  }) async {
    final response = await apiService.post(
      ApiConfig.register,
      {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'whatsapp': whatsapp,
        'domisili': domisili,
      },
    );

    await _saveAuth(response);

    return UserModel.fromJson(
      Map<String, dynamic>.from(response['user'] as Map),
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post(
      ApiConfig.login,
      {
        'email': email,
        'password': password,
      },
    );

    await _saveAuth(response);

    return UserModel.fromJson(
      Map<String, dynamic>.from(response['user'] as Map),
    );
  }

  Future<UserModel> getProfile() async {
    final response = await apiService.getAuthenticated(ApiConfig.me);

    return UserModel.fromJson(
      Map<String, dynamic>.from(response['user'] as Map),
    );
  }

  Future<void> logout() async {
    try {
      await apiService.postAuthenticated(ApiConfig.logout);
    } finally {
      await storageService.clearAuth();
    }
  }

  Future<void> _saveAuth(Map<String, dynamic> response) async {
    final token = response['token']?.toString();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan dari server.');
    }

    final user = Map<String, dynamic>.from(response['user'] as Map);

    await storageService.saveToken(token);
    await storageService.saveUser(user);
  }
}