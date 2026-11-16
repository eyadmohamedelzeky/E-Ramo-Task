/// The signed-in user shown at the top of the "المزيد" drawer.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.city,
    required this.avatarAsset,
  });

  final String name;
  final String city;
  final String avatarAsset;
}
