// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:async_list_view/async_list_view.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/notification_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/business_logic/notifications_bloc.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/notifications_page/notification_view.dart';

class NotificationsPageView extends StatefulWidget {
  const NotificationsPageView({super.key});

  @override
  State<NotificationsPageView> createState() => _NotificationsPageViewState();
}

class _NotificationsPageViewState extends State<NotificationsPageView> {
  final Stream<CastMeNotification> oldNotifications =
      NotificationDatabase.instance.oldNotificationStream();

  @override
  Widget build(BuildContext context) {
    return CastMePage(
      scrollable: false,
      padding: EdgeInsets.zero,
      child: ValueListenableBuilder<List<CastMeNotification>>(
        valueListenable: NotificationBloc.instance.realtimeNotifications,
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
              return AdaptiveMaterial(
                material: notification.base.read
                    ? AdaptiveMaterialType.surface
                    : AdaptiveMaterialType.secondary,
                child: Column(
                  children: [
                    if (index == 0) const Divider(height: .5),
                    NotificationView(notification: notification),
                    const Divider(height: .5),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
