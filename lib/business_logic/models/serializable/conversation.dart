// Package imports:
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';

part 'conversation.freezed.dart';

part 'conversation.g.dart';

/// flutter pub run build_runner build
@freezed
class Conversation with _$Conversation {
  // flutter pub run build_runner build
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

  List<Cast> get allCasts => [rootCast, if (casts != null) ...casts!]
      .sortedBy((c) => c.createdAtStamp)
      .toList();

  List<Cast> get newCasts =>
      allCasts.where((c) => !c.deleted).where((c) => !c.hasViewed).toList();

  int get castCount => allCasts.where((c) => !c.deleted).length;

  int get newCastCount => newCasts.where((c) => !c.deleted).length;

  int get likeCount => allCasts
      .where((c) => !c.deleted)
      .fold(0, (sum, c) => sum += c.likes?.length ?? 0);

  Duration get contentLength => allCasts
      .where((c) => !c.deleted)
      .fold<Duration>(Duration.zero, (sum, b) => sum + b.duration);

  Duration get newContentLength => newCasts
      .where((c) => !c.deleted)
      .fold<Duration>(Duration.zero, (sum, b) => sum + b.duration);

  bool get hasNewCasts => newCasts.isNotEmpty;

  // The root cast is the only cast and it has been deleted.
  bool get isEmpty => rootCast.deleted && castCount == 0;

  bool get isNotEmpty => !isEmpty;
}
