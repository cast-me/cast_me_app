// Flutter imports:
import 'package:cast_me_app/widgets/notifications_page/notifications_page_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:implicit_navigator/implicit_navigator.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:cast_me_app/pages/listen_page_view.dart';
import 'package:cast_me_app/pages/post_page_view.dart';
import 'package:cast_me_app/pages/profile_page_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_bottom_sheet.dart';
import 'package:cast_me_app/widgets/common/cast_me_navigation_bar.dart';
import 'package:cast_me_app/widgets/common/cast_me_page.dart';
import 'package:cast_me_app/widgets/profile_page/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CastMeView extends StatefulWidget {
  const CastMeView({super.key});

  @override
  State<CastMeView> createState() => _CastMeViewState();
}

class _CastMeViewState extends State<CastMeView> {
  @override
  void initState() {
    super.initState();
    const String opensSinceLastRequestKey = 'opens';
    // Put this here so that we only ask after the user has logged in.
    FirebaseMessaging.instance.getNotificationSettings().then((settings) async {
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined ||
          settings.authorizationStatus == AuthorizationStatus.denied) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final int opensSinceLastRequest =
            prefs.getInt(opensSinceLastRequestKey) ?? 0;
        // Only ask once every ten opens so as not to spam users.
        if (opensSinceLastRequest % 10 == 0) {
          await prefs.setInt(
            opensSinceLastRequestKey,
            opensSinceLastRequest + 1,
          );
          await FirebaseMessaging.instance.requestPermission();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ImplicitNavigator.fromValueListenable<SelectedProfile?>(
      key: const PageStorageKey('selected_profile_key'),
      maintainHistory: true,
      valueListenable: CastMeBloc.instance.selectedProfile,
      onPop: (_, afterPop) {
        CastMeBloc.instance.onUsernameSelected(afterPop?.username);
      },
      transitionDuration: const Duration(milliseconds: 100),
      transitionsBuilder: ImplicitNavigator.materialRouteTransitionsBuilder,
      getDepth: (selectedProfile) => selectedProfile == null ? 0 : 1,
      builder: (context, selectedProfile, animation, secondaryAnimation) {
        if (selectedProfile != null) {
          return CastMePage(
            headerText: 'Profile',
            child: FutureBuilder<Profile>(
              future: selectedProfile.profile,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Container();
                }
                return ProfileView(profile: snap.data!);
              },
            ),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ImplicitNavigator.fromValueListenable<CastMeTab>(
                      key: const PageStorageKey('cast_tab_key'),
                      maintainHistory: true,
                      maintainState: true,
                      valueListenable: CastMeBloc.instance.currentTab,
                      transitionDuration: const Duration(milliseconds: 100),
                      onPop: (_, tabAfterPop) =>
                          CastMeBloc.instance.onTabChanged(tabAfterPop),
                      getDepth: (tab) => tab == CastMeTab.listen ? 0 : 1,
                      builder:
                          (context, currentTab, animation, secondaryAnimation) {
                        return Builder(
                          builder: (context) {
                            switch (currentTab) {
                              case CastMeTab.listen:
                                return const ListenPageView();
                              case CastMeTab.post:
                                return const PostPageView();
                              case CastMeTab.notifications:
                                return const NotificationsPageView();
                              case CastMeTab.profile:
                                return const ProfilePageView();
                            }
                          },
                        );
                      },
                    ),
                  ),
                  // Dummy nav bar that's hidden under the real one to
                  // ensure that the real one doesn't cover up the page.
                  const CastMeNavigationBar(tab: CastMeTab.listen),
                ],
              ),
              const CastMeBottomSheet(),
            ],
          ),
        );
      },
    );
  }
}
