// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/util/color_utils.dart';
import 'package:cast_me_app/util/uri_utils.dart';

part 'cast.freezed.dart';

part 'cast.g.dart';

@freezed
class Cast with _$Cast {
  const factory Cast({
    // Server specified.
    required String id,
    required String createdAt,

    // Fetched on read via join.
    required String rootId,
    required String authorUsername,
    required String authorDisplayName,
    required String imageUrl,
    required String? accentColorBase,
    required int viewCount,
    required bool hasViewed,
    required bool treeHasNewCasts,
    required List<Like>? likes,
    // We use names instead of a topic data model because we need to perform an
    // array agg to filter and that only works with raw text values.
    required List<String>? topicNames,
    required List<String>? taggedUsernames,

    // Client specified.
    required String authorId,
    required String title,
    required int durationMs,
    required String audioUrl,
    required String? replyTo,
    required String? externalUrl,
  }) = _Cast;

  // Required by freezed to support custom methods.
  const Cast._();

  factory Cast.fromJson(Map<String, Object?> json) => _$CastFromJson(json);

  /// Helpers.
  Uri get imageUri => Uri.parse(imageUrl);

  Uri get audioUri => Uri.parse(audioUrl);

  Uri? get externalUri => UriUtils.tryParse(externalUrl);

  String get audioPath => audioUri.pathSegments.last;

  DateTime get createdAtStamp => DateTime.parse(createdAt);

  Color get accentColor =>
      ColorUtils.deserialize(accentColorBase ?? 'FFFFFFFF');

  Duration get duration => Duration(milliseconds: durationMs);

  bool get isEmpty => id.isEmpty;

  bool get isNotEmpty => id.isNotEmpty;

  bool get userLiked => (likes ?? [])
      .any((like) => AuthManager.instance.profile.id == like.userId);
}

@freezed
class WriteCast with _$WriteCast {
  const factory WriteCast({
    // Client specified.
    required String authorId,
    required String title,
    required int durationMs,
    required String audioUrl,
    required String? replyTo,
    required String? externalUrl,
  }) = _WriteCast;

  factory WriteCast.fromJson(Map<String, Object?> json) =>
      _$WriteCastFromJson(json);
}

@freezed
class Like with _$Like {
  const factory Like({
    // Server specified.
    required String createdAt,
    required String userId,

    // Fetched on read.
    required String userDisplayName,
  }) = _Like;

  // Required by freezed to support custom methods.
  const Like._();

  factory Like.fromJson(Map<String, Object?> json) => _$LikeFromJson(json);
}
