// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_material/adaptive_material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/widgets/common/cast_me_navigation_bar.dart';
import 'package:cast_me_app/widgets/common/size_reporting_container.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';

class CastMeBottomSheet extends StatefulWidget {
  const CastMeBottomSheet({Key? key}) : super(key: key);

  @override
  State<CastMeBottomSheet> createState() => _CastMeBottomSheetState();
}

class _CastMeBottomSheetState extends State<CastMeBottomSheet> {
  final ValueNotifier<SheetProgress> sheetProgress = ValueNotifier(
    const SheetProgress(0, null, 1),
  );

  DraggableScrollableController get sheetController =>
      ListenBloc.instance.sheetController;

  @override
  void initState() {
    super.initState();
    sheetController.addListener(_onSheetChange);
  }

  @override
  void dispose() {
    sheetController.removeListener(_onSheetChange);
    super.dispose();
  }

  void _onSheetChange() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sheetProgress.value = sheetProgress.value.copyWith(
        size: sheetController.size,
      );
    });
  }

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
                child: CastMeNavigationBar(tab: tab),
              );
            }
            return Column(
              children: [
                // Shim at the top of the screen that pulls down to hide the
                // awkward view padding gap that the sheet can't occupy.
                if (MediaQuery.of(context).viewPadding.top != 0)
                  IgnorePointer(
                    child: ValueListenableBuilder<SheetProgress>(
                      valueListenable: sheetProgress,
                      builder: (context, progress, _) {
                        return Opacity(
                          opacity: progress.current ?? 0,
                          child: AdaptiveMaterial.surface(
                            child: Container(
                              height: MediaQuery.of(context).viewPadding.top,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: _Sheet(
                    sheetProgress: sheetProgress,
                    sheetController: sheetController,
                    tab: tab,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Sheet extends StatefulWidget {
  const _Sheet({
    Key? key,
    required this.sheetProgress,
    required this.sheetController,
    required this.tab,
  }) : super(key: key);

  final ValueNotifier<SheetProgress> sheetProgress;
  final DraggableScrollableController sheetController;
  final CastMeTab tab;

  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  double? nowPlayingHeight;
  double? navBarHeight;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Assume a min height of 60 to avoid issues.
        final double minSize =
            ((nowPlayingHeight ?? 0) + (navBarHeight ?? 100)) /
                constraints.maxHeight;
        return Offstage(
          // Don't display until after we've gotten the nav bar height.
          offstage: navBarHeight == null,
          child: DraggableScrollableSheet(
            controller: widget.sheetController,
            snap: true,
            minChildSize: minSize,
            maxChildSize: 1,
            initialChildSize: minSize,
            builder: (context, controller) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                widget.sheetProgress.value =
                    widget.sheetProgress.value.copyWith(
                  minSize: minSize,
                  maxSize: 1,
                );
              });
              return AdaptiveMaterial.surface(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: controller,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ValueListenableBuilder<SheetProgress>(
                                    valueListenable: widget.sheetProgress,
                                    builder: (context, progress, child) {
                                      return Opacity(
                                        opacity: progress.current ?? 0,
                                        child: child!,
                                      );
                                    },
                                    child: Column(
                                      children: const [
                                        _DragHandle(),
                                        Expanded(
                                          child: NowPlayingExpandedView(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ValueListenableBuilder<SheetProgress>(
                                    valueListenable: widget.sheetProgress,
                                    builder: (context, progress, child) {
                                      return Opacity(
                                        // Fade out fully by the halfway point.
                                        opacity:
                                            (1 - 2 * (progress.current ?? 0))
                                                .clamp(0, 1)
                                                .toDouble(),
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
                            if (MediaQuery.of(context).viewPadding.bottom != 0)
                              AdaptiveMaterial.surface(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).viewPadding.bottom,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ValueListenableBuilder<SheetProgress>(
                        valueListenable: widget.sheetProgress,
                        builder: (context, progress, child) {
                          return FractionalTranslation(
                            translation: Offset(0, progress.current ?? 0),
                            child: child!,
                          );
                        },
                        child: SizeReportingContainer(
                          sizeCallback: (size) {
                            if (navBarHeight != size.height) {
                              setState(() {
                                navBarHeight = size.height;
                              });
                            }
                          },
                          child: CastMeNavigationBar(tab: widget.tab),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
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

class SheetProgress {
  const SheetProgress(this.size, this.minSize, this.maxSize);

  SheetProgress copyWith({
    double? size,
    double? minSize,
    double? maxSize,
  }) {
    return SheetProgress(
      size ?? this.size,
      minSize ?? this.minSize,
      maxSize ?? this.maxSize,
    );
  }

  final double size;
  final double? maxSize;
  final double? minSize;

  double? get current {
    if (maxSize == null || minSize == null) {
      return null;
    }
    // Sometimes size gets updated before minSize.
    if (size < minSize!) {
      return size;
    }
    return (size - minSize!) / (maxSize! - minSize!);
  }
}
