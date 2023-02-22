import 'package:cast_me_app/business_logic/clients/notification_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/business_logic/models/serializable/notification.dart';
import 'package:cast_me_app/business_logic/notifications_bloc.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/text_with_tappable_usernames.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({
    required this.notification,
    super.key,
  });

  final CastMeNotification notification;

  @override
  Widget build(BuildContext context) {
    switch (notification.base.type) {
      case NotificationType.reply:
        return ReplyNotificationView(
          notification: notification as ReplyNotification,
        );
      case NotificationType.like:
        return LikeNotificationView(
          notification: notification as LikeNotification,
        );
      case NotificationType.tag:
        return TagNotificationView(
          notification: notification as TagNotification,
        );
    }
  }
}

class ReplyNotificationView extends StatelessWidget {
  const ReplyNotificationView({
    required this.notification,
    super.key,
  });

  final ReplyNotification notification;

  @override
  Widget build(BuildContext context) {
    return _BaseNotificationView(
      notification: notification,
      icon: const Icon(Icons.reply, color: Colors.white),
      image: PreviewThumbnail(
        imageUrl: notification.data.replyCast.imageUrl,
        username: notification.data.replyCast.authorUsername,
      ),
      title: TappableUsernameText(
        notification.base.title,
      ),
      body: CastPreview(
        cast: notification.data.replyCast,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class LikeNotificationView extends StatelessWidget {
  const LikeNotificationView({
    required this.notification,
    super.key,
  });

  final LikeNotification notification;

  @override
  Widget build(BuildContext context) {
    return _BaseNotificationView(
      notification: notification,
      icon: const Icon(Icons.thumb_up, color: Colors.white),
      image: AspectRatio(
        aspectRatio: 1,
        child: PreviewThumbnail(
          imageUrl: notification.data.profile.profilePictureUrl,
          username: notification.data.profile.username,
        ),
      ),
      title: TappableUsernameText(notification.base.title),
      body: CastPreview(
        cast: notification.data.cast,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class TagNotificationView extends StatelessWidget {
  const TagNotificationView({
    super.key,
    required this.notification,
  });

  final TagNotification notification;

  @override
  Widget build(BuildContext context) {
    return _BaseNotificationView(
      notification: notification,
      icon: const Icon(Icons.label, color: Colors.white),
      image: AspectRatio(
        aspectRatio: 1,
        child: PreviewThumbnail(
          imageUrl: notification.data.cast.imageUrl,
          username: notification.data.cast.authorUsername,
        ),
      ),
      title: TappableUsernameText(notification.base.title),
      body: CastPreview(
        cast: notification.data.cast,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _BaseNotificationView extends StatelessWidget {
  const _BaseNotificationView({
    required this.notification,
    required this.icon,
    required this.image,
    required this.title,
    required this.body,
  });

  final CastMeNotification notification;

  final Widget icon;

  final Widget image;

  final Widget title;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    // Use this toggleable solution so only unread notifications check their
    // visibility.
    return IndicateViewed(
      isUnread: !notification.base.read,
      child: _ToggleVisibilityDetector(
        visibilityKey: ValueKey(notification.base.id),
        isEnabled: !notification.base.read,
        onVisibilityChanged: (visibility) async {
          // Count the notification as read if more than 75% of it is visible.
          if (visibility.visibleFraction > .75) {
            await NotificationDatabase.instance.markAsRead(notification.base.id);
          }
        },
        child: CastViewTheme(
          isInteractive: false,
          indentReplies: false,
          indicateNew: false,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7.5, bottom: 2),
                    child:
                        HowOldLine(createdAt: notification.base.createdAtStamp),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: icon,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Theme.of(context).iconTheme.size,
                                  width: Theme.of(context).iconTheme.size,
                                  child: image,
                                ),
                                const SizedBox(width: 4),
                                Expanded(child: title),
                              ],
                            ),
                            const SizedBox(height: 4),
                            body,
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              NotificationBloc.instance.onNotificationTapped(notification);
            },
          ),
        ),
      ),
    );
  }
}

class _ToggleVisibilityDetector extends StatelessWidget {
  const _ToggleVisibilityDetector({
    required this.visibilityKey,
    required this.isEnabled,
    required this.onVisibilityChanged,
    required this.child,
  });

  final Key visibilityKey;

  final bool isEnabled;
  final VisibilityChangedCallback onVisibilityChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return child;
    }
    return VisibilityDetector(
      key: visibilityKey,
      child: child,
      onVisibilityChanged: onVisibilityChanged,
    );
  }
}
