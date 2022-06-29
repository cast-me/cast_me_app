import 'package:cast_me_app/widgets/CastMeView.dart';

import 'package:flutter/material.dart';

void main() {
  // The entry point to a Flutter app.
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
      home: const CastMeView(),
    );
  }
}
