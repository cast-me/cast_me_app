import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/pages/listen_page_view.dart';
import 'package:cast_me_app/pages/post_page_view.dart';
import 'package:cast_me_app/pages/profile_page_view.dart';
import 'package:cast_me_app/widgets/common/cast_me_navigation_bar.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:implicit_navigator/implicit_navigator.dart';

class CastMeView extends StatelessWidget {
  const CastMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImplicitNavigator.selectFromListenable<ValueListenable<CastMeTab>,
        CastMeTab>(
      listenable: CastMeBloc.instance.currentTab,
      selector: () => CastMeBloc.instance.currentTab.value,
      onPop: (_, tabAfterPop) => CastMeBloc.instance.onTabChanged(tabAfterPop),
      transitionsBuilder: ImplicitNavigator.materialRouteTransitionsBuilder,
      getDepth: (tab) => tab == CastMeTab.listen ? 0 : 1,
      builder: (context, currentTab, animation, secondaryAnimation) {
        return ValueListenableBuilder<bool>(
          valueListenable: ListenBloc.instance.nowPlayingIsExpanded,
          builder: (context, isExpanded, child) {
            return Scaffold(
              // Used to avoid the faint grey line between the navigation bar
              // and the body when both are the same color.
              backgroundColor: currentTab == CastMeTab.listen
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.surface,
              bottomNavigationBar: isExpanded
                  ? null
                  : CastMeNavigationBar(
                      currentIndex: CastMeTabs.tabToIndex(currentTab),
                    ),
              body: child,
            );
          },
          child: Builder(
            builder: (BuildContext context) {
              switch (currentTab) {
                case CastMeTab.listen:
                  return const ListenPageView();
                case CastMeTab.post:
                  return const PostPageView();
                case CastMeTab.profile:
                  return const ProfilePageView();
              }
            },
          ),
        );
      },
    );
  }
}
