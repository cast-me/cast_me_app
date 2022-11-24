// Dart imports:
import 'dart:collection';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/util/custom_icons.dart';

class CastMeTabs {
  const CastMeTabs._();

  static CastMeTab indexToTab(int tabIndex) => tabs.keys.elementAt(tabIndex);

  static LinkedHashMap<CastMeTab, NavigationDestination> tabs =
      LinkedHashMap.fromEntries([
    const MapEntry(
      CastMeTab.listen,
      NavigationDestination(
        icon: Icon(Icons.play_arrow),
        label: 'listen',
      ),
    ),
    const MapEntry(
      CastMeTab.post,
      NavigationDestination(
        icon: Icon(CustomIcons.castMe),
        label: 'post',
      ),
    ),
    const MapEntry(
      CastMeTab.profile,
      NavigationDestination(
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
