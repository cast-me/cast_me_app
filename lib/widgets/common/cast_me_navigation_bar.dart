// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CastMeNavigationBar extends StatelessWidget {
  const CastMeNavigationBar({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final CastMeTab tab;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isVisible) {
        if (isVisible) {
          // Don't show the nav bar if the keyboard is visible.
          return Container();
        }
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Colors.black54,
            labelTextStyle: MaterialStateProperty.all(
              Theme.of(context).textTheme.bodyText1,
            ),
          ),
          child: MediaQuery(
            // NavigationBar wraps itself in `SafeArea` which accidentally applied
            // top padding nonsense. Stop it from doing so.
            data: MediaQuery.of(context)
                .removeViewInsets(removeTop: true)
                .removePadding(removeTop: true),
            child: NavigationBar(
              selectedIndex: tab.index,
              onDestinationSelected: (index) {
                CastMeBloc.instance.onTabIndexChanged(index);
              },
              destinations: CastMeTabs.tabs.values.toList(),
            ),
          ),
        );
      }
    );
  }
}
