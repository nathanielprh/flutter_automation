import '../../domain/entities/profile_entity.dart';

import '../../domain/repositories/profile_repository.dart';

import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ProfileEntity> getProfile() {
    return remoteDatasource.getProfile();
  }

  @override
  Future<ProfileEntity> updateUsername(String username) {
    return remoteDatasource.updateUsername(username);
  }
}
