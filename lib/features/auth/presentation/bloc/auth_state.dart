abstract class AuthState {}

// Initial system state before determining session validity
class AuthInitial extends AuthState {}

// Shows a full-screen or button spinner during background network tasks
class AuthLoading extends AuthState {}

// User successfully signed in; moves them straight into the chat/conversation dashboard
class AuthenticatedState extends AuthState {}

// No active session or user logged out; displays the login screen
class UnauthenticatedState extends AuthState {}

// User registered successfully (can be used to show a success banner or auto-login)
class AuthRegistered extends AuthState {}

// Failure state holding the server message
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
