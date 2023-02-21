import 'dart:async';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationBloc {
  NotificationBloc._();

  static final NotificationBloc instance = NotificationBloc._();

  late final NotificationController controller = NotificationController._();
}

/// This class holds the forward looking subscription stream and the backward
/// looking paginated stream.
class NotificationController {
  NotificationController._() {
    supabase.channel('public:$_tableName').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: _tableName,
        filter: '$userIdCol=eq.${AuthManager.instance.user!.id}',
      ),
      (dynamic payload, [dynamic ref]) {
        realtimeNotifications.value = <CastMeNotification>[
          CastMeNotification.fromJson(
              (payload as Map<String, dynamic>)['new'] as Row),
          ...realtimeNotifications.value,
        ];
      },
    ).subscribe();
  }

  ValueNotifier<List<CastMeNotification>> realtimeNotifications =
      ValueNotifier([]);

  Stream<CastMeNotification> oldNotificationStream() {
    PostgrestFilterBuilder builder = supabase
        .from(_tableName)
        .select<Rows>()
        .eq(userIdCol, AuthManager.instance.user!.id);
    if (realtimeNotifications.value.isNotEmpty) {
      // Ensure we don't get any duplicate notifications.
      builder = builder.lt(
        createdAtCol,
        realtimeNotifications.value.last.baseNotification.createdAt,
      );
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
}

const String _tableName = isStaging ? 'staging_notifications' : 'notifications';
