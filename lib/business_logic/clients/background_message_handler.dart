// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageHandler extends StatefulWidget {
  const FirebaseMessageHandler({
    super.key,
    required this.child,
    required this.onMessage,
  });

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


