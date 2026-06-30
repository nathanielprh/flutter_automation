import 'package:dio/dio.dart';
import 'package:flutter_automation/features/auth/domain/entities/user_entity.dart';

import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<(String access_token, String refresh_token, UserEntity? user)> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/login',

      data: {'email': email, 'password': password},
    );

    print('\n\n this is the login response: $response\n\n');
    String access_token = response.data["access_token"];
    String refresh_token = response.data["refresh_token"];

    UserEntity user = AuthResponseModel.fromJson(response.data["user"]);
    print("for the datasource ${user.email}");
    return (access_token, refresh_token, user);
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await dio.post(
      '/auth/register',

      data: {'username': username, 'email': email, 'password': password},
    );
  }

  Future<String> getRefreshToken(String? refreshToken) async {
    final response = await dio.post(
      "/auth/refresh_token",
      data: {"refresh_token": refreshToken},
    );
    return response.data["access_token"];
  }
}
