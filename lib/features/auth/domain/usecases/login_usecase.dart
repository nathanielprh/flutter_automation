import 'package:flutter_automation/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> call({required String email, required String password}) async {
    await repository.login(email: email, password: password);
  }
}
