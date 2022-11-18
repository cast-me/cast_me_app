// Flutter imports:
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

class CastMeView extends StatelessWidget {
  const CastMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImplicitNavigator.fromValueListenable<SelectedProfile?>(
      key: const PageStorageKey('selected_profile_key'),
      maintainHistory: true,
      valueListenable: CastMeBloc.instance.selectedProfile,
      onPop: (_, afterPop) {
        CastMeBloc.instance.onUsernameSelected(afterPop?.username);
      },
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
                      valueListenable: CastMeBloc.instance.currentTab,
                      onPop: (_, tabAfterPop) =>
                          CastMeBloc.instance.onTabChanged(tabAfterPop),
                      transitionsBuilder: navigationBarTransition,
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
