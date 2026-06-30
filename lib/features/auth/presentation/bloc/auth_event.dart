abstract class AuthEvent {}

// Triggered when the app first launches to check for existing credentials
class CheckAuthStatusEvent extends AuthEvent {}

// Triggered when a user submits the login form
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

// Triggered when a user submits the registration form
class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
  });
}

// Triggered when a user logs out
class LogoutRequested extends AuthEvent {}
