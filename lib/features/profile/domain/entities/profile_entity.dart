/// This is the business object used by the UI.
///
/// Domain entities should NOT know anything
/// about JSON or APIs.
class ProfileEntity {
  final String username;
  final String email;

  const ProfileEntity({required this.username, required this.email});
}
