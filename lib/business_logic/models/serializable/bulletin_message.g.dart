// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulletin_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BulletinMessage _$$_BulletinMessageFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_BulletinMessage',
      json,
      ($checkedConvert) {
        final val = _$_BulletinMessage(
          title: $checkedConvert('title', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_BulletinMessageToJson(_$_BulletinMessage instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
    };
