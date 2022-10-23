import 'dart:async';

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/cast_me_navigation_bar.dart';
import 'package:cast_me_app/widgets/common/size_reporting_container.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CastMeBottomSheet extends StatefulWidget {
  const CastMeBottomSheet({Key? key}) : super(key: key);

  @override
  State<CastMeBottomSheet> createState() => _CastMeBottomSheetState();
}

class _CastMeBottomSheetState extends State<CastMeBottomSheet> {
  final ValueNotifier<double> progress = ValueNotifier(0);
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  double? navBarHeight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Cast?>(
        valueListenable: ListenBloc.instance.currentCast,
        builder: (context, cast, _) {
          return ValueListenableBuilder<CastMeTab>(
            valueListenable: CastMeBloc.instance.currentTab,
            builder: (context, tab, _) {
              if (tab != CastMeTab.listen || cast == null) {
                // Don't apply any of the now playing logic if we're not in
                // the listen tab.
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: SizeReportingContainer(
                    sizeCallback: (size) {
                      if (navBarHeight == size.height) {
                        return;
                      }
                      setState(() {
                        navBarHeight = size.height;
                      });
                    },
                    child: CastMeNavigationBar(tab: tab),
                  ),
                );
              }
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (n) {
                  progress.value =
                      (n.extent - n.minExtent) / (n.maxExtent - n.minExtent);
                  return true;
                },
                child: Column(
                  children: [
                    IgnorePointer(
                      child: ValueListenableBuilder<double>(
                          valueListenable: progress,
                          builder: (context, progress, _) {
                            return Opacity(
                              opacity: progress,
                              child: Container(
                                height: MediaQuery.of(context).viewPadding.top,
                                color: AdaptiveColor.surface.color(context),
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      child: _Sheet(
                        progress: progress,
                        sheetController: sheetController,
                        tab: tab,
                        navBarHeight: navBarHeight,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class _Sheet extends StatefulWidget {
  const _Sheet({
    Key? key,
    required this.progress,
    required this.sheetController,
    required this.tab,
    required this.navBarHeight,
  }) : super(key: key);

  final ValueListenable<double> progress;
  final DraggableScrollableController sheetController;
  final CastMeTab tab;
  final double? navBarHeight;

  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  double? nowPlayingHeight;

  Future<void> onNowPlayingExpansionToggled() async {
    // Collapse the track list on close.
    if (ListenBloc.instance.trackListIsDisplayed.value)
      ListenBloc.instance.onDisplayTrackListToggled();
    await widget.sheetController.animateTo(
      widget.sheetController.size == 1 ? 0 : 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double minSize = ((nowPlayingHeight ?? 0) + widget.navBarHeight!) /
          constraints.maxHeight;
      return DraggableScrollableSheet(
        controller: widget.sheetController,
        snap: true,
        minChildSize: minSize,
        maxChildSize: 1,
        initialChildSize: minSize,
        builder: (context, controller) {
          return AdaptiveMaterial(
            adaptiveColor: AdaptiveColor.surface,
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    height: constraints.maxHeight,
                    child: Stack(
                      children: [
                        // Each of these is individually wrapped in progress so
                        // that we don't have to rebuild the children as we're
                        // scrolling. This is far worse readability but better
                        // performance.
                        // This may not matter, consider removing.
                        ValueListenableBuilder<double>(
                          valueListenable: widget.progress,
                          builder: (context, progress, child) {
                            return Opacity(
                              opacity: progress,
                              child: child!,
                            );
                          },
                          child: Column(
                            children: const [
                              _DragHandle(),
                              Expanded(child: NowPlayingExpandedView()),
                            ],
                          ),
                        ),
                        ValueListenableBuilder<double>(
                          valueListenable: widget.progress,
                          builder: (context, progress, child) {
                            return Opacity(
                              opacity: 1 - progress,
                              child: child!,
                            );
                          },
                          child: SizeReportingContainer(
                            sizeCallback: (size) {
                              if (size.height == nowPlayingHeight) {
                                return;
                              }
                              setState(() {
                                nowPlayingHeight = size.height;
                              });
                            },
                            child: GestureDetector(
                              onTap: onNowPlayingExpansionToggled,
                              child: const NowPlayingCollapsedView(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder<double>(
                    valueListenable: widget.progress,
                    builder: (context, progress, child) {
                      return FractionalTranslation(
                        translation: Offset(0, progress),
                        child: child!,
                      );
                    },
                    child: CastMeNavigationBar(tab: widget.tab),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 20,
        padding: const EdgeInsets.symmetric(vertical: 7.5),
        alignment: Alignment.center,
        child: Container(
          height: 3,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).iconTheme.color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}