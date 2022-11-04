// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/background_message_handler.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/handlers/background_audio_handler.dart';
import 'package:cast_me_app/business_logic/handlers/deep_link_handler.dart';
import 'package:cast_me_app/business_logic/handlers/share_handler.dart';
import 'package:cast_me_app/changelog_messages.dart';
import 'package:cast_me_app/firebase_options.dart';
import 'package:cast_me_app/util/update_message.dart';
import 'package:cast_me_app/widgets/common/auth_gate.dart';
import 'package:cast_me_app/widgets/common/cast_me_view.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      if (Platform.isIOS &&
          (await FirebaseMessaging.instance.getNotificationSettings())
                  .authorizationStatus ==
              AuthorizationStatus.notDetermined) {
        await FirebaseMessaging.instance.requestPermission();
      }
      await Supabase.initialize(
        url: 'https://magmdywarmnzoatbuesp.supabase.co',
        anonKey:
            // ignore: lines_longer_than_80_chars
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hZ21keXdhcm1uem9hdGJ1ZXNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTk3MjQwODIsImV4cCI6MTk3NTMwMDA4Mn0.oclwgOig1Vz8rDDdmf5Is3-ln2ijvfPdkYvUyIA2ZKU',
      );
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );
      await AuthManager.instance.initialize();
      // Ensure analytics has the user id set.
      await Analytics.instance.setUserId(AuthManager.instance.user?.id);
      AuthManager.instance.addListener(() {
        Analytics.instance.setUserId(AuthManager.instance.user?.id);
      });

      await AudioService.init(
        builder: () => BackgroundAudioHandler.instance,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.cast.me.app.channel.audio',
          androidNotificationChannelName: 'Cast playback',
        ),
      );
      await SharedMediaHandler.register(CastMeBloc.instance.onSharedFile);
      await DeepLinkHandler.register(CastMeBloc.instance.onLinkPath);
      await UpdateMessage.register(PackageInfo.fromPlatform());
      runApp(const CastMeApp());
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class CastMeApp extends StatelessWidget {
  const CastMeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: isStaging,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white60),
          floatingLabelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white60),
          ),
          iconColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.grey.shade700,
          surface: Colors.grey.shade900,
          onSurface: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          error: Colors.red.shade200,
          onError: Colors.red.shade900,
        ),
      ),
      home: FirebaseMessageHandler(
        onMessage: CastMeBloc.instance.onFirebaseMessage,
        child: const AuthGate(
          child: UpdateMessage(
            updateMessages: changelogMessages,
            child: CastMeView(),
          ),
        ),
      ),
    );
  }
}
