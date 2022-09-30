import 'dart:async';

import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/stream_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

/// TODO(caseycrogers): this has a lot of duplicative code with
///   `CastAudioPlayer`, consider creating a base class to inherit from.
class ClipAudioPlayer {
  ClipAudioPlayer._();

  static final ClipAudioPlayer instance = ClipAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  PlayerState get playerState => _player.playerState;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<bool> get playingStream => _player.playingStream;

  bool get isCompleted => _player.processingState == ProcessingState.completed;

  String? get currentPath => _player.audioSource == null ||
          _player.processingState == ProcessingState.idle
      ? null
      : (_player.audioSource as UriAudioSource).uri.path;

  late final ValueListenable<double> currentSpeed =
      _player.speedStream.toListenable().map((value) => value ?? 1);

  Future<void> setPath(String? path) async {
    if (path == null) {
      await _player.stop();
      return;
    }
    await _player.setFilePath(path);
  }

  Future<void> play() async {
    unawaited(
      _player.play().then((value) async {
        await pause();
      }),
    );
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seekTo(Duration duration) async {
    await _player.seek(duration);
  }

  Future<void> previous() async {
    await _player.seek(Duration.zero);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
