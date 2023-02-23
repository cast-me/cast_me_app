// Dart imports:
import 'dart:collection';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/notifications_bloc.dart';
import 'package:cast_me_app/main.dart';
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
      CastMeTab.notifications,
      NavigationDestination(
        icon: NotificationsIcon(),
        label: 'notifications',
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
  notifications,
  profile,
}

extension CastMeTabExtension on CastMeTab {
  String get prettyName => name.split('.').last;
}

class NotificationsIcon extends StatelessWidget {
  const NotificationsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(Icons.notifications),
        ValueListenableBuilder<int>(
          valueListenable: NotificationBloc.instance.unreadNotificationCount,
          builder: (context, count, _) {
            if (count == 0) {
              return const SizedBox();
            }
            return Positioned(
              right: 0,
              top: 0,
              height: 14,
              width: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: castMeGrey, width: 2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
