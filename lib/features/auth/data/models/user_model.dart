import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }

  final String uid;
  final String name;
  final String email;
  final String phone;

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'phone': phone};
  }

  @override
  List<Object?> get props => [uid, name, email, phone];
}
