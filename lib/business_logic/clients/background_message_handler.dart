// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // See [DeepLinkHandler], we use it instead of FCM's built in message handler.
  print('Handling a background message: ${message.messageId}');
}

class FirebaseMessageHandler extends StatefulWidget {
  const FirebaseMessageHandler({
    Key? key,
    required this.child,
    required this.onMessage,
  }) : super(key: key);

  final Widget child;
  final Function(Map<String, dynamic>) onMessage;

  @override
  State<FirebaseMessageHandler> createState() => _FirebaseMessageHandlerState();
}

class _FirebaseMessageHandlerState extends State<FirebaseMessageHandler> {
  Future<void> _register() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      widget.onMessage(initialMessage.data);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      widget.onMessage(m.data);
    });
  }

  @override
  void initState() {
    super.initState();
    _register();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
