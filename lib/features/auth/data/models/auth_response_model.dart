import '../../domain/entities/user_entity.dart';

class AuthResponseModel extends UserEntity {
  final String accessToken;

  AuthResponseModel({
    required super.username,
    required super.email,
    required this.accessToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      username: json['username'],
      email: json['email'],
      accessToken: json['access_token'],
    );
  }
}
