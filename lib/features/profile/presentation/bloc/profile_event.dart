abstract class ProfileEvent {}

/// Load profile when page opens
class LoadProfileEvent extends ProfileEvent {}

/// Update username
class UpdateUsernameEvent extends ProfileEvent {
  final String username;

  UpdateUsernameEvent(this.username);
}
