import 'package:movies_app/features/movie_details/domain/entities/cast_member_entity.dart';

class CastMemberModel extends CastMemberEntity {
  const CastMemberModel({
    required super.name,
    required super.character,
    required super.avatarUrl,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      name: json['name'] as String? ?? '',
      character: json['character_name'] as String? ?? '',
      avatarUrl: json['url_small_image'] as String? ?? '',
    );
  }
}
