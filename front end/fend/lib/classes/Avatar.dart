import 'package:fend/screens/HamburgerMenuOptions/AvatarChoice.dart';

final String tableAvatars = 'avatars';

class AvatarFields {
  static final List<String> values = [id, avatar];
  static final String id = '_id';
  static final String avatar = 'avatar';
}

class Avatar {
  final int id;
  final String avatar;

  const Avatar({this.id, this.avatar});

  Avatar copy({
    int id,
    String avatar,
  }) =>
      Avatar(
        id: id ?? this.id,
        avatar: avatar ?? this.avatar,
      );

  static Avatar fromJson(Map<String, Object> json) => Avatar(
        id: json[AvatarFields.id] as int,
        avatar: json[AvatarFields.avatar] as String,
      );

  Map<String, Object> toJson() => {
        AvatarFields.id: id,
        AvatarFields.avatar: avatar,
      };
}
