// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';

part 'conversation.freezed.dart';

part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    // Server specified.
    required String rootId,
    required Cast rootCast,
    required List<Cast> casts,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, Object?> json) =>
      _$ConversationFromJson(json);
}
