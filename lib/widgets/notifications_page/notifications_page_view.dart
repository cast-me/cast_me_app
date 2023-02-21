import 'package:async_list_view/async_list_view.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/business_logic/models/serializable/notification.dart';
import 'package:cast_me_app/business_logic/notifications_bloc.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/notifications_page/notification_view.dart';
import 'package:flutter/material.dart';

class NotificationsPageView extends StatefulWidget {
  const NotificationsPageView({super.key});

  @override
  State<NotificationsPageView> createState() => _NotificationsPageViewState();
}

class _NotificationsPageViewState extends State<NotificationsPageView> {
  final Stream<CastMeNotification> oldNotifications =
      NotificationBloc.instance.controller.oldNotificationStream();

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      scrollable: false,
      padding: EdgeInsets.zero,
      child: ValueListenableBuilder<List<CastMeNotification>>(
        valueListenable:
            NotificationBloc.instance.controller.realtimeNotifications,
        builder: (context, notifications, _) {
          return AsyncListView<CastMeNotification>(
            padding: EdgeInsets.zero,
            initialData: notifications,
            stream: oldNotifications,
            itemBuilder: (context, snapshot, index) {
              if (!snapshot.hasData) {
                return const Text('loading...');
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              final CastMeNotification notification = snapshot.data![index];
              switch (notification.baseNotification.type) {
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
            },
          );
        },
      ),
    );
  }
}
