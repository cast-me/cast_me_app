import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/pages/listen_page_view.dart';
import 'package:cast_me_app/pages/post_page_view.dart';
import 'package:cast_me_app/pages/profile_page_view.dart';
import 'package:cast_me_app/widgets/cast_me_navigation_bar.dart';

import 'package:flutter/material.dart';

class CastMeView extends StatelessWidget {
  const CastMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CastMeTab>(
      valueListenable: CastMeBloc.instance.currentTab,
      builder: (context, currentTab, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: ListenBloc.instance.nowPlayingIsExpanded,
          builder: (context, isExpanded, child) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
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
