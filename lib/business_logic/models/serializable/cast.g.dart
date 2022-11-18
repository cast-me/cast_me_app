// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Cast _$$_CastFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Cast',
      json,
      ($checkedConvert) {
        final val = _$_Cast(
          id: $checkedConvert('id', (v) => v as String),
          createdAt: $checkedConvert('created_at', (v) => v as String),
          rootId: $checkedConvert('root_id', (v) => v as String),
          authorUsername:
              $checkedConvert('author_username', (v) => v as String),
          authorDisplayName:
              $checkedConvert('author_display_name', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          accentColorBase:
              $checkedConvert('accent_color_base', (v) => v as String?),
          viewCount: $checkedConvert('view_count', (v) => v as int),
          hasViewed: $checkedConvert('has_viewed', (v) => v as bool),
          treeHasNewCasts:
              $checkedConvert('tree_has_new_casts', (v) => v as bool),
          likes: $checkedConvert(
              'likes',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Like.fromJson(e as Map<String, dynamic>))
                  .toList()),
          topicNames: $checkedConvert('topic_names',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          taggedUsernames: $checkedConvert('tagged_usernames',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          authorId: $checkedConvert('author_id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          durationMs: $checkedConvert('duration_ms', (v) => v as int),
          audioUrl: $checkedConvert('audio_url', (v) => v as String),
          replyTo: $checkedConvert('reply_to', (v) => v as String?),
          externalUrl: $checkedConvert('external_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'rootId': 'root_id',
        'authorUsername': 'author_username',
        'authorDisplayName': 'author_display_name',
        'imageUrl': 'image_url',
        'accentColorBase': 'accent_color_base',
        'viewCount': 'view_count',
        'hasViewed': 'has_viewed',
        'treeHasNewCasts': 'tree_has_new_casts',
        'topicNames': 'topic_names',
        'taggedUsernames': 'tagged_usernames',
        'authorId': 'author_id',
        'durationMs': 'duration_ms',
        'audioUrl': 'audio_url',
        'replyTo': 'reply_to',
        'externalUrl': 'external_url'
      },
    );

Map<String, dynamic> _$$_CastToJson(_$_Cast instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'root_id': instance.rootId,
      'author_username': instance.authorUsername,
      'author_display_name': instance.authorDisplayName,
      'image_url': instance.imageUrl,
      'accent_color_base': instance.accentColorBase,
      'view_count': instance.viewCount,
      'has_viewed': instance.hasViewed,
      'tree_has_new_casts': instance.treeHasNewCasts,
      'likes': instance.likes?.map((e) => e.toJson()).toList(),
      'topic_names': instance.topicNames,
      'tagged_usernames': instance.taggedUsernames,
      'author_id': instance.authorId,
      'title': instance.title,
      'duration_ms': instance.durationMs,
      'audio_url': instance.audioUrl,
      'reply_to': instance.replyTo,
      'external_url': instance.externalUrl,
    };

_$_WriteCast _$$_WriteCastFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_WriteCast',
      json,
      ($checkedConvert) {
        final val = _$_WriteCast(
          authorId: $checkedConvert('author_id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          durationMs: $checkedConvert('duration_ms', (v) => v as int),
          audioUrl: $checkedConvert('audio_url', (v) => v as String),
          replyTo: $checkedConvert('reply_to', (v) => v as String?),
          externalUrl: $checkedConvert('external_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'authorId': 'author_id',
        'durationMs': 'duration_ms',
        'audioUrl': 'audio_url',
        'replyTo': 'reply_to',
        'externalUrl': 'external_url'
      },
    );

Map<String, dynamic> _$$_WriteCastToJson(_$_WriteCast instance) =>
    <String, dynamic>{
      'author_id': instance.authorId,
      'title': instance.title,
      'duration_ms': instance.durationMs,
      'audio_url': instance.audioUrl,
      'reply_to': instance.replyTo,
      'external_url': instance.externalUrl,
    };

_$_Like _$$_LikeFromJson(Map<String, dynamic> json) => $checkedCreate(
      r'_$_Like',
      json,
      ($checkedConvert) {
        final val = _$_Like(
          createdAt: $checkedConvert('created_at', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String),
          userDisplayName:
              $checkedConvert('user_display_name', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'userId': 'user_id',
        'userDisplayName': 'user_display_name'
      },
    );

Map<String, dynamic> _$$_LikeToJson(_$_Like instance) => <String, dynamic>{
      'created_at': instance.createdAt,
      'user_id': instance.userId,
      'user_display_name': instance.userDisplayName,
    };
