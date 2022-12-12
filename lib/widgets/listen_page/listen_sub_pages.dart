// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/widgets/listen_page/for_you_view.dart';
import 'package:cast_me_app/widgets/listen_page/timeline_view.dart';

class ListenSubPages extends StatelessWidget {
  const ListenSubPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Selector(),
        Expanded(child: _Pages()),
      ],
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: ListenBloc.instance.listenPageController,
      builder: (context, pageIndex, _) {
        final TextStyle labelStyle = Theme.of(context).textTheme.headline5!;
        return BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: pageIndex.round(),
          selectedLabelStyle:
              labelStyle.copyWith(fontSize: labelStyle.fontSize! + 2),
          unselectedLabelStyle:
              labelStyle.copyWith(fontSize: labelStyle.fontSize! - 2),
          iconSize: 0,
          items: const [
            BottomNavigationBarItem(
              icon: SizedBox(),
              label: 'for you',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(),
              label: 'explore',
            ),
          ],
          onTap: ListenBloc.instance.onListenPageChanged,
        );
      },
    );
  }
}

class _Pages extends StatelessWidget {
  const _Pages();

  @override
  Widget build(BuildContext context) {
    return PageView(
      // Dumb hack to trick the `PageView` into keeping it's children in memory.
      allowImplicitScrolling: true,
      controller: ListenBloc.instance.listenPageController,
      children: const [
        ForYouView(),
        TimelineView(),
      ],
    );
  }
}
