// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_notification.dart';

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
