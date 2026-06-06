import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({
    required String username,
    required String email,
    required String password,
  }) async {
    await repository.register(
      username: username,
      email: email,
      password: password,
    );
  }
}
