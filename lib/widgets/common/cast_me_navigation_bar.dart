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
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Colors.black54,
        labelTextStyle: MaterialStateProperty.all(
          Theme.of(context).textTheme.bodyText1,
        ),
      ),
      child: MediaQuery(
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
}
