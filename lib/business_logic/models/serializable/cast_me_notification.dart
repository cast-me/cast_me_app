import 'package:cast_me_app/business_logic/models/serializable/base_notification.dart';
import 'package:cast_me_app/business_logic/models/serializable/reply_notification_data.dart';

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
    }
  }

  final BaseNotification baseNotification;
}

class ReplyNotification extends CastMeNotification {
  ReplyNotification(super.baseNotification, this.data);

  final ReplyNotificationData data;
}