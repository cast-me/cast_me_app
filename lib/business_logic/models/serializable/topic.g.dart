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
          likeCount: $checkedConvert('like_count', (v) => v as int),
          castCount: $checkedConvert('cast_count', (v) => v as int),
          newCastCount: $checkedConvert('new_cast_count', (v) => v as int),
          newConversationCastCount:
              $checkedConvert('new_conversation_cast_count', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'likeCount': 'like_count',
        'castCount': 'cast_count',
        'newCastCount': 'new_cast_count',
        'newConversationCastCount': 'new_conversation_cast_count'
      },
    );

Map<String, dynamic> _$$_TopicToJson(_$_Topic instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'like_count': instance.likeCount,
      'cast_count': instance.castCount,
      'new_cast_count': instance.newCastCount,
      'new_conversation_cast_count': instance.newConversationCastCount,
    };
