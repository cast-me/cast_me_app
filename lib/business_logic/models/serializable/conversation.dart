// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';

part 'conversation.freezed.dart';

part 'conversation.g.dart';

/// flutter pub run build_runner build
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    // Server specified.
    required String rootId,
    required Cast rootCast,
    required List<Cast>? casts,
    required List<String>? topics,
  }) = _Conversation;

  // Required by freezed to support custom methods.
  const Conversation._();

  factory Conversation.fromJson(Map<String, Object?> json) =>
      _$ConversationFromJson(json);

  List<Cast> get allCasts => [rootCast, if (casts != null) ...casts!];

  List<Cast> get newCasts => allCasts.where((c) => !c.hasViewed).toList();

  int get castCount => allCasts.length;

  int get newCastCount => newCasts.length;

  Duration get contentLength =>
      allCasts.fold<Duration>(Duration.zero, (sum, b) => sum + b.duration);

  Duration get newContentLength =>
      newCasts.fold<Duration>(Duration.zero, (sum, b) => sum + b.duration);

  bool get hasNewCasts => newCasts.isNotEmpty;
}
