import 'package:cast_me_app/models/cast_me_model.dart';
import 'package:cast_me_app/models/cast_me_tab.dart';
import 'package:cast_me_app/pages/listen_page_view.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CastMeTab>(
        valueListenable: CastMeModel.instance.currentTab,
        builder: (context, currentTab, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: CastMeTabs.tabToIndex(currentTab),
              selectedItemColor: Colors.white,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).colorScheme.surface,
              items: CastMeTabs.tabs.values.toList(),
              selectedIconTheme: const IconThemeData(size: 36),
              onTap: (tabIndex) {
                CastMeModel.instance
                    .onTabChanged(CastMeTabs.indexToTab(tabIndex));
              },
            ),
            body: Builder(
              builder: (BuildContext context) {
                switch (currentTab) {
                  case CastMeTab.listen:
                    return const ListenPageView();
                  case CastMeTab.post:
                    return Container(color: Colors.orange);
                  case CastMeTab.profile:
                    return Container(color: Colors.pink);
                }
              },
            ),
          );
        });
  }
}
