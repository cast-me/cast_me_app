// Package imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply_notification_data.freezed.dart';

part 'reply_notification_data.g.dart';

/// flutter pub run build_runner build
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
