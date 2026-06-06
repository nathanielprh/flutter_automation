import '../../../../core/network/dio_client.dart';

import '../models/profile_model.dart';

class ProfileRemoteDatasource {
  final DioClient dioClient;

  ProfileRemoteDatasource({required this.dioClient});

  /// Get profile from API
  Future<ProfileModel> getProfile() async {
    final response = await dioClient.dio.get("/users/me");

    return ProfileModel.fromJson(response.data);
  }

  /// Update username
  Future<ProfileModel> updateUsername(String username) async {
    final response = await dioClient.dio.put(
      "/users/me",
      data: {"username": username},
    );

    return ProfileModel.fromJson(response.data);
  }
}
