import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:flutter/material.dart';

class CastMeNavigationBar extends StatelessWidget {
  const CastMeNavigationBar({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final CastMeTab tab;

  // TODO(caseycrogers): programmatize this.
  static const double height = 73.5;

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
