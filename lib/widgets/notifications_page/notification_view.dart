import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/business_logic/models/serializable/notification.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/text_with_tappable_usernames.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({
    super.key,
    required this.baseNotification,
    required this.icon,
    required this.image,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final BaseNotification baseNotification;

  final Widget icon;

  final Widget image;

  final Widget title;

  final Widget body;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CastViewTheme(
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
                child: HowOldLine(createdAt: baseNotification.createdAtStamp),
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
        onTap: onTap,
      ),
    );
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
    return NotificationView(
      baseNotification: notification.baseNotification,
      icon: const Icon(Icons.reply, color: Colors.white),
      image: PreviewThumbnail(
        imageUrl: notification.data.replyCast.imageUrl,
        username: notification.data.replyCast.authorUsername,
      ),
      title: TappableUsernameText(
        notification.baseNotification.title,
      ),
      body: CastPreview(
        cast: notification.data.replyCast,
        padding: EdgeInsets.zero,
      ),
      onTap: () {
        ListenBloc.instance.onCastSelected(notification.data.replyCast);
        ListenBloc.instance.onConversationIdSelected(
          notification.data.replyCast.rootId,
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.listen);
      },
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
    return NotificationView(
      baseNotification: notification.baseNotification,
      icon: const Icon(Icons.thumb_up, color: Colors.white),
      image: AspectRatio(
        aspectRatio: 1,
        child: PreviewThumbnail(
          imageUrl: notification.data.profile.profilePictureUrl,
          username: notification.data.profile.username,
        ),
      ),
      title: TappableUsernameText(notification.baseNotification.title),
      body: CastPreview(
        cast: notification.data.cast,
        padding: EdgeInsets.zero,
      ),
      onTap: () {
        ListenBloc.instance.onConversationIdSelected(
          notification.data.cast.rootId,
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.listen);
      },
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
    return NotificationView(
      baseNotification: notification.baseNotification,
      icon: const Icon(Icons.label, color: Colors.white),
      image: AspectRatio(
        aspectRatio: 1,
        child: PreviewThumbnail(
          imageUrl: notification.data.cast.imageUrl,
          username: notification.data.cast.authorUsername,
        ),
      ),
      title: TappableUsernameText(notification.baseNotification.title),
      body: CastPreview(
        cast: notification.data.cast,
        padding: EdgeInsets.zero,
      ),
      onTap: () {
        ListenBloc.instance.onConversationIdSelected(
          notification.data.cast.rootId,
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.listen);
      },
    );
  }
}
