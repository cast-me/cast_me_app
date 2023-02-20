// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
