import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/cast_view.dart';
import 'package:cast_me_app/widgets/listen_page/track_list_view.dart';
import 'package:cast_me_app/widgets/seek_bar.dart';

import 'package:flutter/material.dart';

class NowPlayingView extends StatelessWidget {
  const NowPlayingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ListenBloc.instance.nowPlayingIsExpanded,
      builder: (context, isExpanded, _) {
        return GestureDetector(
          onTap: ListenBloc.instance.onNowPlayingExpansionToggled,
          child: isExpanded ? const _FullView() : _CollapsedView(),
        );
      },
    );
  }
}

class _CollapsedView extends StatelessWidget {
  final ListenBloc model = CastMeBloc.instance.listenBloc;

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
                  child: CastPreview(
                    cast: cast,
                    fullyInteractive: false,
                  ),
                ),
                const _PlayButton(),
                const _ForwardTen(),
              ],
            ),
            const _NonInteractiveSeekBar(),
          ],
        );
      },
    );
  }
}

class _NonInteractiveSeekBar extends StatelessWidget {
  const _NonInteractiveSeekBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: CastAudioPlayer.instance.positionDataStream,
      builder: (context, positionSnap) {
        return LinearProgressIndicator(
          minHeight: 1,
          value: positionSnap.data?.progress,
          color: ListenBloc.instance.currentCast.value!.accentColor,
          backgroundColor: Theme.of(context).colorScheme.background,
        );
      },
    );
  }
}

class _FullView extends StatelessWidget {
  const _FullView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ValueListenableBuilder<Cast?>(
          valueListenable: ListenBloc.instance.currentCast,
          builder: (context, cast, _) {
            return ValueListenableBuilder<bool>(
                valueListenable: ListenBloc.instance.trackListIsDisplayed,
                builder: (context, displayTrackList, _) {
                  return Column(
                    children: [
                      if (!displayTrackList)
                        Column(
                          children: [
                            CastView(cast: cast!),
                            const SeekBar(),
                          ],
                        ),
                      if (displayTrackList)
                        const SizedBox(
                          height: 200,
                          child: TrackListView(),
                        ),
                      _FullAudioControls(cast: cast!),
                    ],
                  );
                });
          }),
    );
  }
}

class _FullAudioControls extends StatelessWidget {
  const _FullAudioControls({
    Key? key,
    required this.cast,
  }) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _TrackListButton(),
          ),
        ),
        const _BackTen(),
        const _PlayButton(isCircle: true),
        const _ForwardTen(),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.one_x_mobiledata),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackListButton extends StatelessWidget {
  const _TrackListButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.playlist_play),
      onPressed: () {
        ListenBloc.instance.onDisplayTrackListToggled();
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key, this.isCircle = false}) : super(key: key);

  final bool isCircle;

  IconData get playIcon => isCircle ? Icons.play_circle : Icons.play_arrow;

  IconData get pauseIcon => isCircle ? Icons.pause_circle : Icons.pause;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (CastAudioPlayer.instance.playerState.playing) {
          CastAudioPlayer.instance.pause();
        } else {
          CastAudioPlayer.instance.unPause();
        }
      },
      iconSize: isCircle ? IconTheme.of(context).size! + 36 : null,
      icon: StreamBuilder<bool>(
        stream: CastAudioPlayer.instance.playingStream,
        builder: (context, playingSnap) {
          return Icon(
            playingSnap.data ?? false ? pauseIcon : playIcon,
          );
        },
      ),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class _ForwardTen extends StatelessWidget {
  const _ForwardTen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        CastAudioPlayer.instance.skipForward();
      },
      icon: const Icon(Icons.forward_10),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class _BackTen extends StatelessWidget {
  const _BackTen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        CastAudioPlayer.instance.skipBackward();
      },
      icon: const Icon(Icons.replay_10),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}
