import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/login',

      data: {'email': email, 'password': password},
    );

    print('\n\n this is the login response: $response\n\n');

    return AuthResponseModel.fromJson(response.data);
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
}
