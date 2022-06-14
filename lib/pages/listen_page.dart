import 'package:cast_me_app/mock_data.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/now_playing_view.dart';
import 'package:cast_me_app/widgets/trending_view.dart';

import 'package:flutter/material.dart';

class ListenPage extends StatelessWidget {
  const ListenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AdaptiveMaterial(
        adaptiveColor: AdaptiveColor.background,
        child: Column(
          children: [
            const ListenTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  TrendingView(),
                ],
              ),
            ),
            const AdaptiveMaterial(
              adaptiveColor: AdaptiveColor.surface,
              child: NowPlayingView(cast: ezraLoneliness),
            ),
          ],
        ),
      ),
    );
  }
}

class ListenTopBar extends StatelessWidget {
  const ListenTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Following',
          style: Theme.of(context).textTheme.headline5!.copyWith(
              color: AdaptiveMaterial.onColorOf(context)!.withAlpha(150)),
        ),
        AdaptiveText(
          'Trending',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
