import 'dart:async';

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/notification_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/business_logic/models/serializable/notification.dart';
import 'package:flutter/cupertino.dart';

class NotificationBloc {
  NotificationBloc._();

  static final NotificationBloc instance = NotificationBloc._();

  // Late to ensure that this gets initialized after supabase.
  late final ValueNotifier<List<CastMeNotification>> realtimeNotifications =
      NotificationDatabase.instance.realtimeNotifications();

  Future<void> onNotificationTapped(CastMeNotification notification) async {
    switch (notification.base.type) {
      case NotificationType.reply:
        notification as ReplyNotification;
        ListenBloc.instance.onConversationIdSelected(
          notification.data.replyCast.rootId,
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.listen);
        await ListenBloc.instance.onCastSelected(notification.data.replyCast);
        break;
      case NotificationType.like:
        notification as LikeNotification;
        ListenBloc.instance.onConversationIdSelected(
          notification.data.cast.rootId,
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.listen);
        break;
      case NotificationType.tag:
        notification as TagNotification;
        ListenBloc.instance.onConversationIdSelected(
          notification.data.cast.rootId,
        );
        CastMeBloc.instance.onTabChanged(CastMeTab.listen);
        await ListenBloc.instance.onCastSelected(notification.data.cast);
        break;
    }
  }
}
