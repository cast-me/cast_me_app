import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:flutter/material.dart';

class CastMeNavigationBar extends StatelessWidget {
  const CastMeNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ListenBloc.instance.nowPlayingIsExpanded,
      builder: (context, isExpanded, _) {
        if (isExpanded) {
          return Container();
        }
        return BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).colorScheme.surface,
          items: CastMeTabs.tabs.values.toList(),
          selectedIconTheme: const IconThemeData(size: 36),
          onTap: (tabIndex) {
            CastMeBloc.instance.onTabChanged(CastMeTabs.indexToTab(tabIndex));
          },
          elevation: 0,
        );
      },
    );
  }
}
