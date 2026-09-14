class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int? avatarIndex;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarIndex,
    this.profileImageUrl,
  });
}