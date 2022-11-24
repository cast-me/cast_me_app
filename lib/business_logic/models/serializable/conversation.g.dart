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
        );
        return val;
      },
      fieldKeyMap: const {'rootId': 'root_id', 'rootCast': 'root_cast'},
    );

Map<String, dynamic> _$$_ConversationToJson(_$_Conversation instance) =>
    <String, dynamic>{
      'root_id': instance.rootId,
      'root_cast': instance.rootCast.toJson(),
      'casts': instance.casts?.map((e) => e.toJson()).toList(),
      'topics': instance.topics,
    };
