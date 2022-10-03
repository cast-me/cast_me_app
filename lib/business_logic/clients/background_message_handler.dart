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
  print('Handling a background message: ${message.messageId}');
}
