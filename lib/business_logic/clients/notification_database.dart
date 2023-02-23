// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';

class NotificationDatabase {
  NotificationDatabase._();

  static NotificationDatabase instance = NotificationDatabase._();

  Stream<CastMeNotification> oldNotificationStream({String? startBeforeDate}) {
    PostgrestFilterBuilder builder = supabase
        .from(_tableName)
        .select<Rows>()
        .eq(userIdCol, AuthManager.instance.user!.id);
    if (startBeforeDate != null) {
      // Ensure we don't get any duplicate notifications.
      builder = builder.lt(createdAtCol, startBeforeDate);
    }
    return paginated(
      builder.order(createdAtCol, ascending: false),
      chunkSize: 10,
    ).map(CastMeNotification.fromJson).handleError(
      (Object error, StackTrace stackTrace) {
        FlutterError.onError!.call(
          FlutterErrorDetails(exception: error, stack: stackTrace),
        );
      },
    );
  }

  ValueNotifier<List<CastMeNotification>> realtimeNotifications() {
    final ValueNotifier<List<CastMeNotification>> notifications =
        ValueNotifier([]);
    supabase.channel('public:notification_list').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: _tableName,
        filter: '$userIdCol=eq.${AuthManager.instance.user!.id}',
      ),
      (dynamic payload, [dynamic ref]) {
        notifications.value = <CastMeNotification>[
          CastMeNotification.fromJson(
              (payload as Map<String, dynamic>)['new'] as Row),
          ...notifications.value,
        ];
      },
    ).subscribe();
    return notifications;
  }

  ValueNotifier<int> unreadNotificationCount() {
    final ValueNotifier<int> notificationCount = ValueNotifier(0);
    getUnreadNotificationCount()
        .then((count) => notificationCount.value = count);
    supabase.channel('public:notification_count').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: '*',
        schema: 'public',
        table: _tableName,
        filter: '$userIdCol=eq.${AuthManager.instance.user!.id}',
      ),
      (dynamic payload, [dynamic ref]) async {
        notificationCount.value = await getUnreadNotificationCount();
      },
    ).subscribe();
    return notificationCount;
  }

  @visibleForTesting
  static void reset() {
    instance = NotificationDatabase._();
  }

  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from(_tableName)
        .update(<String, dynamic>{readCol: true}).eq(idCol, notificationId);
  }

  Future<int> getUnreadNotificationCount() async {
    return (await supabase
            .from(_countTableName)
            .select<PostgrestMap>('unread_notifications')
            .eq(idCol, AuthManager.instance.profile.id)
            .single())
        .values
        .single as int;
  }
}

const String _tableName = isStaging ? 'staging_notifications' : 'notifications';
const String _countTableName = '${_tableName}_count';
