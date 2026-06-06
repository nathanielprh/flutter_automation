import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_automation/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_automation/features/auth/domain/usecases/register_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  final RegisterUseCase registerUseCase;

  AuthBloc(this.loginUseCase, this.registerUseCase) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await loginUseCase(email: event.email, password: event.password);

        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await registerUseCase(
          username: event.username,
          email: event.email,
          password: event.password,
        );

        emit(AuthRegistered());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
