// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/widgets/listen_page/audio_playback_controls.dart';
import 'package:cast_me_app/widgets/listen_page/seek_bar.dart';
import 'package:cast_me_app/widgets/post_page/trim_controls.dart';

class FileAudioPlayerControls extends StatelessWidget {
  const FileAudioPlayerControls({
    super.key,
    required this.castFile,
  });

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    final ClipAudioPlayer player = ClipAudioPlayer.instance;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SeekBar(
          positionDataStream: player.positionDataStream,
          seekTo: player.seekTo,
        ),
        StreamBuilder<bool>(
          stream: player.playingStream,
          builder: (context, playingSnap) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    CutFromStart(castFile: castFile),
                    const SizedBox(width: 8),
                    CutFromEnd(castFile: castFile),
                    const SizedBox(width: 8),
                    _DenoiseButton(castFile: castFile),
                    const SizedBox(width: 8),
                    _Undo(castFile: castFile),
                  ],
                ),
                Wrap(
                  children: [
                    IgnorePointer(
                      child: Opacity(
                        opacity: 0,
                        child: PlaybackSpeedButton(
                          currentSpeed: ClipAudioPlayer.instance.currentSpeed,
                          setSpeed: ClipAudioPlayer.instance.setSpeed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const TickBackward(),
                    const SizedBox(width: 8),
                    _PlayButton(
                      isPlaying: playingSnap.data ?? false,
                      path: castFile.file.path,
                    ),
                    const SizedBox(width: 8),
                    const TickForward(),
                    const SizedBox(width: 12),
                    PlaybackSpeedButton(
                      currentSpeed: ClipAudioPlayer.instance.currentSpeed,
                      setSpeed: ClipAudioPlayer.instance.setSpeed,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DenoiseButton extends StatelessWidget {
  const _DenoiseButton({
    required this.castFile,
  });

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    return AsyncElevatedButton(
      action: 'denoise',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (castFile.isDenoised)
            const Icon(Icons.check_box)
          else
            const Icon(Icons.check_box_outline_blank),
          const SizedBox(width: 4),
          const Text('denoise'),
        ],
      ),
      onTap: _toggle,
    );
  }

  Future<void> _toggle() async {
    await ClipAudioPlayer.instance.pause();
    await PostBloc.instance.onFileUpdated(await castFile.toggleDenoised());
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.isPlaying,
    this.path,
  });

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

class _Undo extends StatelessWidget {
  const _Undo({required this.castFile});

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Trim>(
      valueListenable: castFile.trim,
      builder: (context, _, __) {
        return ElevatedButton(
          child: const Icon(Icons.undo),
          onPressed: castFile.trim.canUndo ? castFile.trim.undo : null,
        );
      },
    );
  }
}
