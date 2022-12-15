// Flutter imports:
import 'dart:ui';

import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
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
    final ValueListenablePageController controller =
        ListenBloc.instance.listenPageController;
    return ValueListenableBuilder<double>(
      valueListenable: controller,
      builder: (context, pageIndex, _) {
        return DefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: AdaptiveMaterial.onColorOf(context)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _TabButton(
                  index: 0,
                  child: const Text('for you'),
                  currentIndex: controller.value,
                  onTap: () {
                    controller.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                    );
                  },
                ),
              ),
              Expanded(
                child: _TabButton(
                  index: 1,
                  child: const Text('explore'),
                  currentIndex: controller.value,
                  onTap: () {
                    controller.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  _TabButton({
    required double currentIndex,
    required this.index,
    required this.child,
    required this.onTap,
  }) : relativeDistance = (currentIndex - index).clamp(-1, 1);

  // How close this tab is to being selected, 1, -1 meaning not at all, 0
  // meaning selected.
  final double relativeDistance;
  final double index;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle activeTextStyle = DefaultTextStyle.of(context).style;
    final Color animatedColor = Color.lerp(
      activeTextStyle.color,
      AdaptiveMaterial.secondaryOnColorOf(context),
      relativeDistance.abs(),
    )!;
    return InkWell(
      onTap: onTap,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 6,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 4,
                  width: 40 * (1 - 2*relativeDistance.abs()).clamp(0, 1),
                  decoration: BoxDecoration(
                    color: animatedColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 12),
              height: activeTextStyle.fontSize! + 12,
              child: DefaultTextStyle(
                child: child,
                style: activeTextStyle.copyWith(
                  color: animatedColor,
                ),
              ),
            ),
          ],
        ),
      ),
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
