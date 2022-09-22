import 'dart:collection';

import 'package:cast_me_app/util/custom_icons.dart';
import 'package:flutter/material.dart';

class CastMeTabs {
  const CastMeTabs._();

  static CastMeTab indexToTab(int tabIndex) => tabs.keys.elementAt(tabIndex);

  static int tabToIndex(CastMeTab tabIndex) =>
      tabs.keys.toList().indexOf(tabIndex);

  static LinkedHashMap<CastMeTab, BottomNavigationBarItem> tabs =
      LinkedHashMap.fromEntries([
    const MapEntry(
      CastMeTab.listen,
      BottomNavigationBarItem(
        icon: Icon(Icons.play_arrow),
        label: 'listen',
      ),
    ),
    const MapEntry(
      CastMeTab.post,
      BottomNavigationBarItem(
        icon: Icon(CustomIcons.castMe),
        label: 'post',
      ),
    ),
    const MapEntry(
      CastMeTab.profile,
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'profile',
      ),
    ),
  ]);
}

enum CastMeTab {
  listen,
  post,
  profile,
}

extension CastMeTabExtension on CastMeTab {
  String get prettyName => name.split('.').last;
}
