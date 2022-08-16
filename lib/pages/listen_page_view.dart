import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/listen_page/listen_tab_selector.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';
import 'package:cast_me_app/widgets/listen_page/tab_switcher.dart';

import 'package:flutter/material.dart';

class ListenPageView extends StatelessWidget {
  const ListenPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ListenBloc.instance.nowPlayingIsExpanded,
      builder: (context, isExpanded, child) {
        return Stack(
          children: [
            child!,
            if (isExpanded)
              Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.black38,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      onTap: () {
                        ListenBloc.instance.onNowPlayingExpansionToggled();
                      },
                    ),
                  ),
                  const AdaptiveMaterial(
                    adaptiveColor: AdaptiveColor.surface,
                    child: SafeArea(child: NowPlayingFullView()),
                  ),
                ],
              ),
          ],
        );
      },
      child: AdaptiveMaterial(
        adaptiveColor: AdaptiveColor.background,
        child: SafeArea(
          child: Column(
            children: const [
              ListenTabSelector(),
              Expanded(
                child: ListenTabView(),
              ),
              AdaptiveMaterial(
                adaptiveColor: AdaptiveColor.surface,
                child: NowPlayingView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
