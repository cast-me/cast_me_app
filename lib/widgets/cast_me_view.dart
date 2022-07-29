import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/pages/listen_page_view.dart';

import 'package:flutter/material.dart';

class CastMeView extends StatelessWidget {
  const CastMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CastMeTab>(
        valueListenable: CastMeBloc.instance.currentTab,
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
                CastMeBloc.instance
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
