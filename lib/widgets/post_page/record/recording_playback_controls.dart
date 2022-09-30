import 'dart:async';

import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/record_bloc.dart';
import 'package:cast_me_app/widgets/listen_page/audio_playback_controls.dart';
import 'package:flutter/material.dart';

class RecordingPlaybackControls extends StatelessWidget {
  const RecordingPlaybackControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClipAudioPlayer player = ClipAudioPlayer.instance;
    return ValueListenableBuilder<String?>(
      valueListenable: RecordBloc.instance.recordingPath,
      builder: (context, path, _) {
        return StreamBuilder<bool>(
          stream: player.playingStream,
          builder: (context, playingSnap) {
            return Row(
              children: [
                ElevatedButton(
                  onPressed: path == null
                      ? null
                      : () {
                          player.previous();
                        },
                  child: const Icon(Icons.skip_previous),
                ),
                const SizedBox(width: 8),
                _PlayButton(
                  isPlaying: playingSnap.data ?? false,
                  path: path,
                ),
                const SizedBox(width: 8),
                PlaybackSpeedButton(
                  currentSpeed: ClipAudioPlayer.instance.currentSpeed,
                  setSpeed: ClipAudioPlayer.instance.setSpeed,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key, required this.isPlaying, this.path})
      : super(key: key);

  final bool isPlaying;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final ClipAudioPlayer player = ClipAudioPlayer.instance;
    if (!isPlaying) {
      return ElevatedButton(
        onPressed: path == null
            ? null
            : () async {
                if (player.isCompleted) {
                  await player.previous();
                }
                unawaited(player.play());
              },
        child: const Icon(Icons.play_arrow),
      );
    }
    return ElevatedButton(
      onPressed: path == null
          ? null
          : () async {
              await player.pause();
            },
      child: const Icon(Icons.pause),
    );
  }
}
