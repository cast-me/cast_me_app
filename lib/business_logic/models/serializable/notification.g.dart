// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BaseNotification _$$_BaseNotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_BaseNotification',
      json,
      ($checkedConvert) {
        final val = _$_BaseNotification(
          id: $checkedConvert('id', (v) => v as String),
          createdAt: $checkedConvert('created_at', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String),
          typeId: $checkedConvert('type_id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          read: $checkedConvert('read', (v) => v as bool),
          data: $checkedConvert('data', (v) => v as Map<String, dynamic>),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'userId': 'user_id',
        'typeId': 'type_id'
      },
    );

Map<String, dynamic> _$$_BaseNotificationToJson(_$_BaseNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'user_id': instance.userId,
      'type_id': instance.typeId,
      'title': instance.title,
      'read': instance.read,
      'data': instance.data,
    };

_$_ReplyNotificationData _$$_ReplyNotificationDataFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_ReplyNotificationData',
      json,
      ($checkedConvert) {
        final val = _$_ReplyNotificationData(
          originalCast: $checkedConvert(
              'original_cast', (v) => Cast.fromJson(v as Map<String, dynamic>)),
          replyCast: $checkedConvert(
              'reply_cast', (v) => Cast.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'originalCast': 'original_cast',
        'replyCast': 'reply_cast'
      },
    );

Map<String, dynamic> _$$_ReplyNotificationDataToJson(
        _$_ReplyNotificationData instance) =>
    <String, dynamic>{
      'original_cast': instance.originalCast.toJson(),
      'reply_cast': instance.replyCast.toJson(),
    };

_$_LikeNotificationData _$$_LikeNotificationDataFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_LikeNotificationData',
      json,
      ($checkedConvert) {
        final val = _$_LikeNotificationData(
          profile: $checkedConvert(
              'profile', (v) => Profile.fromJson(v as Map<String, dynamic>)),
          cast: $checkedConvert(
              'cast', (v) => Cast.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_LikeNotificationDataToJson(
        _$_LikeNotificationData instance) =>
    <String, dynamic>{
      'profile': instance.profile.toJson(),
      'cast': instance.cast.toJson(),
    };

_$_TagNotificationData _$$_TagNotificationDataFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_TagNotificationData',
      json,
      ($checkedConvert) {
        final val = _$_TagNotificationData(
          cast: $checkedConvert(
              'cast', (v) => Cast.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_TagNotificationDataToJson(
        _$_TagNotificationData instance) =>
    <String, dynamic>{
      'cast': instance.cast.toJson(),
    };
