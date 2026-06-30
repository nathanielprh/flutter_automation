import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_automation/features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final hasSession = await repository.hasValidSession();
      if (hasSession) {
        emit(AuthenticatedState());
      } else {
        emit(UnauthenticatedState());
      }
    } catch (_) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Adjusted here: Capturing the UserEntity returned from the repository
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );

      //print("Logged in successfully as: ${user.email}"); // Verification check

      emit(AuthenticatedState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.register(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      emit(AuthRegistered());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.logout();
      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
