// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';

class CutFromStart extends StatelessWidget {
  const CutFromStart({
    Key? key,
    required this.castFile,
  }) : super(key: key);

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    return _Cut(
      castFile: castFile,
      cutFromStart: true,
    );
  }
}

class CutFromEnd extends StatelessWidget {
  const CutFromEnd({
    Key? key,
    required this.castFile,
  }) : super(key: key);

  final CastFile castFile;

  @override
  Widget build(BuildContext context) {
    return _Cut(
      castFile: castFile,
      cutFromStart: false,
    );
  }
}

class TickForward extends StatelessWidget {
  const TickForward({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PositionDependentButton(
      disableAtEnd: true,
      builder: (context, _, enabled) {
        return ElevatedButton(
          onPressed: enabled
              ? () {
                  ClipAudioPlayer.instance
                      .tick(const Duration(milliseconds: 100));
                }
              : null,
          child: const Icon(Icons.fast_forward),
        );
      },
    );
  }
}

class TickBackward extends StatelessWidget {
  const TickBackward({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PositionDependentButton(
      disableAtStart: true,
      builder: (context, _, isEnabled) {
        return ElevatedButton(
          onPressed: isEnabled
              ? () {
                  ClipAudioPlayer.instance
                      .tick(const Duration(milliseconds: -100));
                }
              : null,
          child: const Icon(Icons.fast_rewind),
        );
      },
    );
  }
}

class _Cut extends StatelessWidget {
  const _Cut({
    Key? key,
    required this.cutFromStart,
    required this.castFile,
  }) : super(key: key);

  final bool cutFromStart;
  final CastFile castFile;

  bool get cutFromEnd => !cutFromStart;

  ClipAudioPlayer get player => ClipAudioPlayer.instance;

  @override
  Widget build(BuildContext context) {
    return _PositionDependentButton(
      disableAtStart: cutFromStart,
      disableAtEnd: cutFromEnd,
      builder: (context, position, enabled) {
        return ElevatedButton(
          child: Transform(
            transform:
                cutFromStart ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
            alignment: Alignment.center,
            child: const Icon(Icons.cut),
          ),
          onPressed: enabled
              ? () {
                  final Trim oldTrim = castFile.trim.value;
                  // We add the start back in because the audio player is
                  // measuring our position relative to start but trim expects
                  // the start relative to the underlying file.
                  castFile.trim.value = Trim(
                    start: cutFromStart
                        ? oldTrim.start + player.position!
                        : oldTrim.start,
                    end: cutFromEnd
                        ? oldTrim.start + player.position!
                        : oldTrim.end,
                  );
                }
              : null,
        );
      },
    );
  }
}

class _PositionDependentButton extends StatelessWidget {
  const _PositionDependentButton({
    Key? key,
    required this.builder,
    this.disableAtEnd = false,
    this.disableAtStart = false,
  }) : super(key: key);

  final Widget Function(BuildContext, Duration?, bool) builder;
  final bool disableAtEnd;
  final bool disableAtStart;

  ClipAudioPlayer get player => ClipAudioPlayer.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: ClipAudioPlayer.instance.positionDataStream,
      builder: (context, positionSnap) {
        return builder(context, positionSnap.data?.duration, enabled);
      },
    );
  }

  bool get enabled {
    if (player.position == null || player.duration == null) {
      return false;
    }
    if (disableAtStart && player.position == Duration.zero) {
      return false;
    }
    if (disableAtEnd &&
        (player.position == player.duration || player.isCompleted)) {
      return false;
    }
    return true;
  }
}
