import 'package:flutter_automation/features/auth/domain/entities/user_entity.dart';

class AuthResponseModel extends UserEntity {
  AuthResponseModel({required super.username, required super.email});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
