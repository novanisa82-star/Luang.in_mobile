import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';

  Future<void> saveToken(String token) async {
    await _storage.write(tokenKey, token);
  }

  String? getToken() {
    return _storage.read<String>(tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(userKey, user);
  }

  Map<String, dynamic>? getUser() {
    final data = _storage.read(userKey);

    if (data == null) return null;

    return Map<String, dynamic>.from(data);
  }

  Future<void> clearAuth() async {
    await _storage.remove(tokenKey);
    await _storage.remove(userKey);
  }

  bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}