import 'package:flutter_automation/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_automation/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_automation/core/storage/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  final SecureStorageService storage;

  AuthRepositoryImpl({required this.remoteDataSource, required this.storage});

  @override
  Future<void> login({required String email, required String password}) async {
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );
    await storage.saveToken(response.accessToken);
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
}
