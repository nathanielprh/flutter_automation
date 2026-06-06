import '../../domain/entities/profile_entity.dart';

/// Model knows how to convert JSON
/// from the backend into Dart objects.
class ProfileModel extends ProfileEntity {
  const ProfileModel({required super.username, required super.email});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(username: json["username"], email: json["email"]);
  }

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email};
  }
}
