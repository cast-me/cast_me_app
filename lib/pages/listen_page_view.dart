import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/listen_page/listen_tab_selector.dart';
import 'package:cast_me_app/widgets/listen_page/now_playing_view.dart';
import 'package:cast_me_app/widgets/listen_page/tab_switcher.dart';

import 'package:flutter/material.dart';

class ListenPageView extends StatelessWidget {
  const ListenPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AdaptiveMaterial(
        adaptiveColor: AdaptiveColor.background,
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
    );
  }
}
