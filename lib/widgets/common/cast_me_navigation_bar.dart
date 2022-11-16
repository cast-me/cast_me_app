// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';

class CastMeNavigationBar extends StatelessWidget {
  const CastMeNavigationBar({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final CastMeTab tab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tab.index,
      selectedItemColor: Colors.white,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      items: CastMeTabs.tabs.values.toList(),
      selectedIconTheme: const IconThemeData(size: 36),
      onTap: (tabIndex) {
        CastMeBloc.instance.onTabIndexChanged(tabIndex);
      },
      elevation: 0,
    );
  }
}

Widget navigationBarTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}
