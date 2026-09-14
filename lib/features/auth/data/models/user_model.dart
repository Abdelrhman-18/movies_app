import 'package:movies_app/features/auth/domain/entities/user.dart';

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

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarIndex: avatarIndex,
      profileImageUrl: profileImageUrl,
    );
  }
}