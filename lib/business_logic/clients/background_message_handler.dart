// Package imports:
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Handles push notifications from Firebase Cloud Messaging.
/// See: https://firebase.flutter.dev/docs/messaging/usage
class CastMeBackgroundMessageHandler {
  CastMeBackgroundMessageHandler._();

  static void register() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // See [DeepLinkHandler], we use it instead of FCM's built in message handler.
  print('Handling a background message: ${message.messageId}');
}
