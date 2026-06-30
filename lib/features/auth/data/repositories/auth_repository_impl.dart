import 'package:flutter_automation/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_automation/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_automation/core/storage/secure_storage_service.dart';
import 'package:flutter_automation/features/auth/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storage;

  AuthRepositoryImpl({required this.remoteDataSource, required this.storage});

  @override
  Future<UserEntity?> login({
    required String email,
    required String password,
  }) async {
    // Capturing all 3 values emitted by your FastAPI backend datasource
    final (accessToken, refreshToken, user) = await remoteDataSource.login(
      email: email,
      password: password,
    );

    // Securely cache the new JWT pair
    await storage.clearToken();
    await storage.saveToken(accessToken);
    await storage.saveRefreshToken(refreshToken);

    //print("repositoryImple user: ${user.email}");
    // Return the user model up to the Domain layer
    return user;
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await remoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<bool> hasValidSession() async {
    final token = await storage.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await storage.clearToken();
    await storage.clearRefreshToken();
    // If your secure storage service has a method to clear the refresh token:
    // await storage.clearRefreshToken();
  }

  @override
  Future<void> getRefreshToken() async {
    final String? savedRefreshToken = await storage.getRefreshToken();
    if (savedRefreshToken == null) throw Exception("No refresh token found");

    // Requesting a fresh short-lived access token from FastAPI
    final String newAccessToken = await remoteDataSource.getRefreshToken(
      savedRefreshToken,
    );

    await storage.clearToken();
    await storage.saveToken(newAccessToken);
  }
}
