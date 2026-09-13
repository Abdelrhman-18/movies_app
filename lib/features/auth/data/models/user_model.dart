class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int? avatarIndex;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarIndex,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json,
      String id,
      ) {
    return UserModel(
      id: id,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarIndex: json['avatarIndex'] as int?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarIndex': avatarIndex,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    int? avatarIndex,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}