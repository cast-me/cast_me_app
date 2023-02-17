// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Conversation _$$_ConversationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_Conversation',
      json,
      ($checkedConvert) {
        final val = _$_Conversation(
          rootId: $checkedConvert('root_id', (v) => v as String),
          rootCast: $checkedConvert(
              'root_cast', (v) => Cast.fromJson(v as Map<String, dynamic>)),
          casts: $checkedConvert(
              'casts',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
                  .toList()),
          topics: $checkedConvert('topics',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          castCount: $checkedConvert('cast_count', (v) => v as int),
          newCastCount: $checkedConvert('new_cast_count', (v) => v as int),
          isPrivate: $checkedConvert('is_private', (v) => v as bool),
          visibleTo: $checkedConvert('visible_to',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'rootId': 'root_id',
        'rootCast': 'root_cast',
        'castCount': 'cast_count',
        'newCastCount': 'new_cast_count',
        'isPrivate': 'is_private',
        'visibleTo': 'visible_to'
      },
    );

Map<String, dynamic> _$$_ConversationToJson(_$_Conversation instance) =>
    <String, dynamic>{
      'root_id': instance.rootId,
      'root_cast': instance.rootCast.toJson(),
      'casts': instance.casts?.map((e) => e.toJson()).toList(),
      'topics': instance.topics,
      'cast_count': instance.castCount,
      'new_cast_count': instance.newCastCount,
      'is_private': instance.isPrivate,
      'visible_to': instance.visibleTo,
    };
