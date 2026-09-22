import 'package:equatable/equatable.dart';

class CastMemberEntity extends Equatable {
  const CastMemberEntity({
    required this.name,
    required this.character,
    required this.avatarUrl,
  });

  final String name;
  final String character;
  final String avatarUrl;

  @override
  List<Object?> get props => [name, character, avatarUrl];
}
