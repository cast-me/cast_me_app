import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/cast_view.dart';

import 'package:flutter/material.dart';

class NowPlayingView extends StatefulWidget {
  const NowPlayingView({Key? key}) : super(key: key);

  @override
  State<NowPlayingView> createState() => _NowPlayingViewState();
}

class _NowPlayingViewState extends State<NowPlayingView> {
  Duration? progressDuration = const Duration(seconds: 100);

  final ListenBloc model = CastMeBloc.instance.listenModel;

  double get progress =>
      progressDuration!.inMilliseconds /
      model.currentCast.value!.duration.inMilliseconds;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Cast?>(
      valueListenable: model.currentCast,
      builder: (context, cast, _) {
        if (cast == null) {
          return Container();
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CastPreview(cast: cast),
                ),
                IconButton(
                  onPressed: () {
                    if (model.player.playerState.playing) {
                      model.player.pause();
                    } else {
                      model.player.play(cast);
                    }
                  },
                  icon: StreamBuilder<bool>(
                      stream: model.player.playingStream,
                      builder: (context, playingSnap) {
                        return Icon(
                          playingSnap.data ?? false
                              ? Icons.pause
                              : Icons.play_arrow,
                        );
                      }),
                  color: AdaptiveMaterial.onColorOf(context),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.skip_next),
                  color: AdaptiveMaterial.onColorOf(context),
                ),
              ],
            ),
            StreamBuilder<PositionData>(
                stream: ListenBloc.instance.player.positionDataStream,
                builder: (context, positionSnap) {
                  return LinearProgressIndicator(
                    minHeight: 1,
                    value: progress,
                    color: cast.accentColor,
                    backgroundColor: Theme.of(context).colorScheme.background,
                  );
                }),
          ],
        );
      },
    );
  }
}
