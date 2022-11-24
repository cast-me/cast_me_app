// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';

class AudioPlaybackControls extends StatelessWidget {
  const AudioPlaybackControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TrackListButton(),
          ),
        ),
        const PreviousCast(),
        const PlayButton(isCircle: true),
        const SkipCast(),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: PlaybackSpeedButton(
              currentSpeed: CastAudioPlayer.instance.currentSpeed,
              setSpeed: CastAudioPlayer.instance.setSpeed,
            ),
          ),
        ),
      ],
    );
  }
}

class PreviousCast extends StatelessWidget {
  const PreviousCast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await CastAudioPlayer.instance.previous();
      },
      icon: const Icon(Icons.skip_previous),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class SkipCast extends StatelessWidget {
  const SkipCast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await CastAudioPlayer.instance.skip();
      },
      icon: const Icon(Icons.skip_next),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class ForwardTen extends StatelessWidget {
  const ForwardTen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await CastAudioPlayer.instance.forwardTen();
      },
      icon: const Icon(Icons.forward_10),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class BackTen extends StatelessWidget {
  const BackTen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await CastAudioPlayer.instance.backwardTen();
      },
      icon: const Icon(Icons.replay_10),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key, this.isCircle = false}) : super(key: key);

  final bool isCircle;

  IconData get playIcon => isCircle ? Icons.play_circle : Icons.play_arrow;

  IconData get pauseIcon => isCircle ? Icons.pause_circle : Icons.pause;

  @override
  Widget build(BuildContext context) {
    return PlayWrapper(
      iconSize: isCircle ? IconTheme.of(context).size! + 36 : null,
      onPlay: CastAudioPlayer.instance.unPause,
      onPause: CastAudioPlayer.instance.pause,
      builder: (context, isPlaying) {
        return Icon(
          isPlaying ? pauseIcon : playIcon,
        );
      },
    );
  }
}

class PlayWrapper extends StatelessWidget {
  const PlayWrapper({
    Key? key,
    required this.onPlay,
    required this.onPause,
    required this.builder,
    this.iconSize,
  }) : super(key: key);

  final AsyncCallback onPlay;
  final AsyncCallback onPause;
  final Widget Function(BuildContext, bool) builder;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      onPressed: () {
        if (CastAudioPlayer.instance.playerState.playing) {
          onPause();
        } else {
          onPlay();
        }
      },
      icon: StreamBuilder<bool>(
        stream: CastAudioPlayer.instance.playingStream,
        builder: (context, playingSnap) {
          return builder(context, playingSnap.data ?? false);
        },
      ),
      color: AdaptiveMaterial.onColorOf(context),
    );
  }
}

class PlaybackSpeedButton extends StatefulWidget {
  const PlaybackSpeedButton({
    Key? key,
    required this.currentSpeed,
    required this.setSpeed,
  }) : super(key: key);

  final ValueListenable<double> currentSpeed;
  final Future<void> Function(double) setSpeed;

  @override
  State<PlaybackSpeedButton> createState() => _PlaybackSpeedButtonState();
}

class _PlaybackSpeedButtonState extends State<PlaybackSpeedButton> {
  static const _speeds = [
    3.0,
    2.5,
    2.0,
    1.5,
    1.0,
  ];

  DragStartDetails? dragStartDetails;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.currentSpeed,
      builder: (context, speed, _) {
        return DropdownButton<double>(
          value: speed,
          icon: Container(),
          underline: Container(),
          items: _speeds.map(
            (speed) {
              return DropdownMenuItem<double>(
                value: speed,
                child: Text('${speed}x'),
                onTap: () => widget.setSpeed(speed),
              );
            },
          ).toList(),
          onChanged: (index) {},
        );
      },
    );
  }
}

class TrackListButton extends StatelessWidget {
  const TrackListButton({Key? key}) : super(key: key);

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
