import 'package:cast_me_app/business_logic/models/serializable/notification.dart';

abstract class CastMeNotification {
  CastMeNotification(this.baseNotification);

  factory CastMeNotification.fromJson(Map<String, Object?> json) {
    final BaseNotification baseNotification = BaseNotification.fromJson(json);
    switch (baseNotification.type) {
      case NotificationType.reply:
        return ReplyNotification(
          baseNotification,
          ReplyNotificationData.fromJson(baseNotification.data),
        );
      case NotificationType.like:
        return LikeNotification(
          baseNotification,
          LikeNotificationData.fromJson(baseNotification.data),
        );
      case NotificationType.tag:
        return TagNotification(
          baseNotification,
          TagNotificationData.fromJson(baseNotification.data),
        );
    }
  }

  final BaseNotification baseNotification;
}

class ReplyNotification extends CastMeNotification {
  ReplyNotification(super.baseNotification, this.data);

  final ReplyNotificationData data;
}

class LikeNotification extends CastMeNotification {
  LikeNotification(super.baseNotification, this.data);

  final LikeNotificationData data;
}

class TagNotification extends CastMeNotification {
  TagNotification(super.baseNotification, this.data);

  final TagNotificationData data;
}
