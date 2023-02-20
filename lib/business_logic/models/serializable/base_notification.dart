// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_notification.freezed.dart';

part 'base_notification.g.dart';

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
}

extension BaseNotificationUtils on BaseNotification {
  NotificationType get type =>
      NotificationType.values.singleWhere((type) => type.id == typeId);
}

enum NotificationType {
  reply,
}

extension Ids on NotificationType {
  String get id {
    switch (this) {
      case NotificationType.reply:
        return 'de7e120b-4b42-42fb-86d4-8c32804ebf3c';
    }
  }
}
