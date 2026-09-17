import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarIndex,
    this.profileImageUrl,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final int? avatarIndex;
  final String? profileImageUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    avatarIndex,
    profileImageUrl,
  ];
}
