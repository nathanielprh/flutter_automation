import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Fetch current logged in user profile
  Future<ProfileEntity> getProfile();

  /// Update username
  Future<ProfileEntity> updateUsername(String username);
}
