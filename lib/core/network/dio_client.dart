import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';

class DioClient {
  final SecureStorageService storage;
  late final Dio dio;
  late final Dio refreshDio;
  bool _isRefreshing = false;

  DioClient(this.storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 25),
      ),
    );

    refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          if (kDebugMode) {
            print("--- Outgoing Request Context ---");
            print("Target: ${options.path}");
            print("Headers: ${options.headers}");
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          // Check for unauthorized status and avoid nested refresh loops
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            if (kDebugMode)
              print("🔒 Token expired (401). Attempting background refresh...");
            _isRefreshing = true;

            final success = await _refreshToken();

            _isRefreshing = false;

            if (success) {
              if (kDebugMode)
                print(
                  "✅ Token refreshed successfully. Retrying original request...",
                );
              final newToken = await storage.getToken();
              final request = error.requestOptions;

              request.headers["Authorization"] = "Bearer $newToken";

              // Clone and execute the original request context
              final response = await dio.fetch(request);
              return handler.resolve(response);
            }

            if (kDebugMode)
              print(
                "❌ Token refresh failed. Purging local secure session cache...",
              );
            await storage.clearToken();
            await storage.clearRefreshToken();
          }

          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        if (kDebugMode) print("Refresh abort: No token in storage.");
        return false;
      }

      // Synchronized endpoint matching your AuthRemoteDataSource definition
      final response = await refreshDio.post(
        "/auth/refresh_token",
        data: {"refresh_token": refreshToken},
      );

      // Extract token value
      final newToken = response.data["access_token"];
      if (newToken == null) return false;

      await storage.saveToken(newToken);
      return true;
    } catch (e) {
      if (kDebugMode) print("Refresh failure exception: $e");
      return false;
    }
  }
}
