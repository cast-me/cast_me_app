// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';

part 'topic.g.dart';

/// flutter pub run build_runner build
@freezed
class Topic with _$Topic {
  const factory Topic({
    required String name,
    required String id,
    required int likeCount,
    required int castCount,
    required int newCastCount,
    required int newConversationCastCount,
  }) = _Topic;

  const Topic._();

  factory Topic.fromJson(Map<String, Object?> json) =>
      _$TopicFromJson(json);
}
