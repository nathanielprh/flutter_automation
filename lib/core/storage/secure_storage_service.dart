import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'access_token', value: token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<void> clearToken() async {
    await storage.delete(key: 'access_token');
  }

  Future<void> clearRefreshToken() async {
    await storage.delete(key: 'refresh_token');
  }
}
