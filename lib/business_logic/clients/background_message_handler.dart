// Flutter imports:
import 'dart:convert';

import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/business_logic/notifications_bloc.dart';
import 'package:cast_me_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageHandler extends StatefulWidget {
  const FirebaseMessageHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<FirebaseMessageHandler> createState() => _FirebaseMessageHandlerState();
}

class _FirebaseMessageHandlerState extends State<FirebaseMessageHandler> {
  String? msg;

  Future<void> _register() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Ensure that crashes in the message handler will get logged.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await onMessage(initialMessage.data);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      onMessage(m.data);
    });
  }

  @override
  void initState() {
    super.initState();
    _register();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (msg != null)
          Material(
            child: Text(msg!),
          ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }

  Future<void> onMessage(Map<String, dynamic> messageData) async {
    setState(() {
      msg = messageData.containsKey(typeCol).toString();
    });
    if (messageData.containsKey(typeCol)) {
      // The incoming object's formatting is butchered so we have to deserialize
      // some stuff manually.
      messageData['read'] = messageData['read'] == 'true';
      messageData['data'] = jsonDecode(messageData['data']! as String);
      // We know this is the V2 notifications system, unpack it as such.
      final CastMeNotification notification =
          CastMeNotification.fromJson(messageData);
      await NotificationBloc.instance.onNotificationTapped(notification);
    }
    // Legacy. Delete after a couple weeks.
    final String? castId = messageData[castIdCol] as String?;
    if (castId != null) {
      await ListenBloc.instance.onCastIdSelected(
        castId: castId,
        autoplay: true,
      );
    }
  }
}
