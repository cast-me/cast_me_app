import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/listen_page/listen_tab_selector.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';
import 'package:cast_me_app/widgets/listen_page/tab_switcher.dart';

import 'package:flutter/material.dart';

class ListenPageView extends StatefulWidget {
  const ListenPageView({Key? key}) : super(key: key);

  @override
  State<ListenPageView> createState() => _ListenPageViewState();
}

class _ListenPageViewState extends State<ListenPageView> {
  @override
  void initState() {
    if (ListenBloc.instance.currentCast.value == null) {
      CastDatabase.instance.getSeedCast().then((cast) {
        // Seed the now playing cast with content on app launch.
        // Check a second time just in case the user has selected a cast while
        // we were getting the seed cast.
        if (ListenBloc.instance.currentCast.value == null) {
          ListenBloc.instance.onCastSelected(cast, autoPlay: false);
        }
      });
    }
    super.initState();
  }

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
