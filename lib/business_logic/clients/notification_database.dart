import 'dart:async';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    supabase.channel('public:$_tableName').on(
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

  @visibleForTesting
  static void reset() {
    instance = NotificationDatabase._();
  }

  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from(_tableName)
        .update(<String, dynamic>{readCol: true}).eq(idCol, notificationId);
  }
}

const String _tableName = isStaging ? 'staging_notifications' : 'notifications';
