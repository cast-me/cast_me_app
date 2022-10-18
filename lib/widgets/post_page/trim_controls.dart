import 'dart:math' as math;

import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:flutter/material.dart';

class TrimControls extends StatelessWidget {
  const TrimControls({
    Key? key,
    required this.castFile,
  }) : super(key: key);

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<PositionData>(
          stream: ClipAudioPlayer.instance.positionDataStream,
          builder: (context, positionSnap) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Cut(
                  isStart: true,
                  castFile: castFile,
                  position: positionSnap.data?.position ?? Duration.zero,
                ),
                const SizedBox(width: 8),
                _Cut(
                  isStart: false,
                  castFile: castFile,
                  position: positionSnap.data?.position ?? Duration.zero,
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
        _Undo(castFile: castFile),
      ],
    );
  }
}

class _Undo extends StatelessWidget {
  const _Undo({
    Key? key,
    required this.castFile,
  }) : super(key: key);

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Trim>(
      valueListenable: castFile.trim,
      builder: (context, _, __) {
        return IconButton(
          icon: const Icon(Icons.undo),
          onPressed: castFile.trim.canUndo ? castFile.trim.undo : null,
        );
      },
    );
  }
}

class _Cut extends StatelessWidget {
  const _Cut({
    Key? key,
    required this.isStart,
    required this.castFile,
    required this.position,
  }) : super(key: key);

  final bool isStart;
  final CastFile castFile;
  final Duration position;

  bool get isEnd => !isStart;
  ClipAudioPlayer get player => ClipAudioPlayer.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform(
            transform:
                isStart ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
            alignment: Alignment.center,
            child: const Icon(Icons.cut),
          ),
        ],
      ),
      onPressed: canTrim
          ? () {
              final Trim oldTrim = castFile.trim.value;
              // We add the start back in because the audio player is measuring
              // our position relative to start but trim expects the start
              // relative to the underlying file.
              castFile.trim.value = Trim(
                start:
                    isStart ? oldTrim.start + player.position! : oldTrim.start,
                end: isEnd ? oldTrim.start + player.position! : oldTrim.end,
              );
            }
          : null,
    );
  }

  bool get canTrim {
    if (player.position == null || player.duration == null) {
      return false;
    }
    if (isStart && player.position == Duration.zero) {
      return false;
    }
    if (isEnd &&
        (player.position == player.duration || player.isCompleted)) {
      return false;
    }
    return true;
  }
}
