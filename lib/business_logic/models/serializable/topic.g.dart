// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Topic _$$_TopicFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Topic',
      json,
      ($checkedConvert) {
        final val = _$_Topic(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          castCount: $checkedConvert('cast_count', (v) => v as int),
          newCastCount: $checkedConvert('new_cast_count', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'castCount': 'cast_count',
        'newCastCount': 'new_cast_count'
      },
    );

Map<String, dynamic> _$$_TopicToJson(_$_Topic instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'cast_count': instance.castCount,
      'new_cast_count': instance.newCastCount,
    };
