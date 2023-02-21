// Package imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';

part 'notification.g.dart';

/// flutter pub run build_runner build
@freezed
class BaseNotification with _$BaseNotification {
  const factory BaseNotification({
    required String id,
    required String createdAt,
    required String userId,
    required String typeId,
    required String title,
    required bool read,
    // This is a json blob representing the notification-specific data.
    required Map<String, Object?> data,
  }) = _BaseNotification;

  const BaseNotification._();

  factory BaseNotification.fromJson(Map<String, Object?> json) =>
      _$BaseNotificationFromJson(json);

  DateTime get createdAtStamp => DateTime.parse(createdAt);
}

extension BaseNotificationUtils on BaseNotification {
  NotificationType get type =>
      NotificationType.values.singleWhere((type) => type.id == typeId);
}

enum NotificationType {
  reply,
  like,
  tag,
}

extension Ids on NotificationType {
  String get id {
    switch (this) {
      case NotificationType.reply:
        return 'de7e120b-4b42-42fb-86d4-8c32804ebf3c';
      case NotificationType.like:
        return '39f35e9c-0794-4533-a099-bd683f6ee881';
      case NotificationType.tag:
        return '014c0f3d-bbdf-47db-ab35-67f9a5efd8b7';
    }
  }
}

@freezed
class ReplyNotificationData with _$ReplyNotificationData {
  const factory ReplyNotificationData({
    required Cast originalCast,
    required Cast replyCast,
  }) = _ReplyNotificationData;

  const ReplyNotificationData._();

  factory ReplyNotificationData.fromJson(Map<String, Object?> json) =>
      _$ReplyNotificationDataFromJson(json);
}

@freezed
class LikeNotificationData with _$LikeNotificationData {
  const factory LikeNotificationData({
    required Profile profile,
    required Cast cast,
  }) = _LikeNotificationData;

  const LikeNotificationData._();

  factory LikeNotificationData.fromJson(Map<String, Object?> json) =>
      _$LikeNotificationDataFromJson(json);
}

@freezed
class TagNotificationData with _$TagNotificationData {
  const factory TagNotificationData({
    required Cast cast,
  }) = _TagNotificationData;

  const TagNotificationData._();

  factory TagNotificationData.fromJson(Map<String, Object?> json) =>
      _$TagNotificationDataFromJson(json);
}

