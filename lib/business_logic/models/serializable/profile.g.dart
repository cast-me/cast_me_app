// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Profile _$$_ProfileFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Profile',
      json,
      ($checkedConvert) {
        final val = _$_Profile(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          displayName: $checkedConvert('display_name', (v) => v as String),
          profilePictureUrl:
              $checkedConvert('profile_picture_url', (v) => v as String),
          accentColorBase:
              $checkedConvert('accent_color_base', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'displayName': 'display_name',
        'profilePictureUrl': 'profile_picture_url',
        'accentColorBase': 'accent_color_base'
      },
    );

Map<String, dynamic> _$$_ProfileToJson(_$_Profile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'profile_picture_url': instance.profilePictureUrl,
      'accent_color_base': instance.accentColorBase,
    };
