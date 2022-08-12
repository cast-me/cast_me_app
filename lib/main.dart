import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/firebase_options.dart';

import 'package:cast_me_app/widgets/common/auth_gate.dart';
import 'package:cast_me_app/widgets/common/cast_me_view.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://magmdywarmnzoatbuesp.supabase.co',
    anonKey:
        // ignore: lines_longer_than_80_chars
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hZ21keXdhcm1uem9hdGJ1ZXNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTk3MjQwODIsImV4cCI6MTk3NTMwMDA4Mn0.oclwgOig1Vz8rDDdmf5Is3-ln2ijvfPdkYvUyIA2ZKU',
  );
  await AuthManager.instance.initialize();
  runApp(const CastMeApp());
}

class CastMeApp extends StatelessWidget {
  const CastMeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: const AuthGate(child: CastMeView()),
    );
  }
}
