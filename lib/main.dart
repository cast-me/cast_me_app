import 'package:cast_me_app/pages/listen_page.dart';
import 'package:cast_me_app/util/custom_icons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: tabs,
        selectedIconTheme: const IconThemeData(size: 36),
      ),
      body: const ListenPage(),
    );
  }
}

final List<BottomNavigationBarItem> tabs = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.play_arrow),
    label: 'listen',
  ),
  const BottomNavigationBarItem(
    icon: Icon(CustomIcons.cast_me),
    label: 'post',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'profile',
  ),
];
