// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/async_action_wrapper.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/widgets/listen_page/audio_playback_controls.dart';
import 'package:cast_me_app/widgets/listen_page/seek_bar.dart';
import 'package:cast_me_app/widgets/post_page/trim_controls.dart';

class FileAudioPlayerControls extends StatelessWidget {
  const FileAudioPlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CastFile?>(
      valueListenable: PostBloc.instance.castFile,
      builder: (context, castFile, _) {
        if (castFile == null) {
          return Container();
        }
        return _BaseAudioControls(castFile: castFile);
      },
    );
  }
}

class _BaseAudioControls extends StatelessWidget {
  const _BaseAudioControls({
    Key? key,
    required this.castFile,
  }) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _SkipPrevious(),
                    const SizedBox(width: 8),
                    _PlayButton(
                      isPlaying: playingSnap.data ?? false,
                      path: castFile.file.path,
                    ),
                    const SizedBox(width: 8),
                    PlaybackSpeedButton(
                      currentSpeed: ClipAudioPlayer.instance.currentSpeed,
                      setSpeed: ClipAudioPlayer.instance.setSpeed,
                    ),
                    _DenoiseButton(castFile: castFile),
                  ],
                ),
                TrimControls(castFile: castFile),
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
    Key? key,
    required this.castFile,
  }) : super(key: key);

  final CastFile castFile;

  Future<void> _toggle(bool newValue) async {
    await ClipAudioPlayer.instance.pause();
    await PostBloc.instance.onFileUpdated(await castFile.toggleDenoised());
  }

  @override
  Widget build(BuildContext context) {
    final AsyncActionWrapper wrapper = AsyncActionWrapper.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProcessingView(
          child: ValueListenableBuilder<bool>(
            valueListenable: PostBloc.instance.castFile.select(
                () => PostBloc.instance.castFile.value?.isDenoised ?? false),
            builder: (context, value, _) {
              return GestureDetector(
                onTap: () async {
                  await _toggle(!value);
                },
                child: Checkbox(
                  value: value,
                  onChanged: (newValue) {
                    wrapper.wrap(
                      'denoise',
                      () async {
                        await _toggle(!value);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        const Text('denoise'),
      ],
    );
  }
}

class _SkipPrevious extends StatelessWidget {
  const _SkipPrevious({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ClipAudioPlayer.instance.previous();
      },
      child: const Icon(Icons.skip_previous),
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
