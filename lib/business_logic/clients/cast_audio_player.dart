import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/stream_utils.dart';
import 'package:flutter/foundation.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class CastAudioPlayer {
  CastAudioPlayer._() {
    positionDataStream.listen(
      (data) async {
        if (data.position == data.duration && _player.hasNext) {
          await _player.pause();
        }
      },
    );
  }

  static final CastAudioPlayer instance = CastAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  // Add content to this queue.
  ConcatenatingAudioSource? _sourceQueue;

  // Listen for currently playing content from this queue.
  late final ValueListenable<List<IndexedAudioSource>> queue =
      _player.sequenceStream.toListenable().map((lst) => lst ?? []);

  late final ValueListenable<Cast?> currentCast =
      Rx.combineLatest2<int?, List<IndexedAudioSource>?, Cast?>(
    _player.currentIndexStream,
    _player.sequenceStream,
    (index, sequence) {
      if (index == null || sequence == null) {
        return null;
      }
      return sequence[index].cast;
    },
  ).toListenable();

  late final ValueListenable<int?> currentIndex =
      _player.currentIndexStream.toListenable();

  late final ValueListenable<double> currentSpeed =
      _player.speedStream.toListenable().map((value) => value ?? 1);

  PlayerState get playerState => _player.playerState;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<bool> get playingStream => _player.playingStream;

  /// Delete the queue and play [cast].
  Future<void> play(Cast cast) async {
    if (cast == currentCast.value) {
      return;
    }
    _sourceQueue = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: [
        AudioSource.uri(
          cast.audioUri,
          tag: cast,
        ),
      ],
    );
    _player.setAudioSource(_sourceQueue!);
    await _player.play();
  }


  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> unPause() async {
    await _player.play();
  }

  Future<void> seekTo(Duration duration) async {
    await _player.seek(duration);
  }

  Future<void> skipForward() async {
    await seekTo(_player.position + const Duration(seconds: 10));
  }

  Future<void> skipBackward() async {
    await seekTo(_player.position - const Duration(seconds: 10));
  }

  Future<void> setSpeed(double newSpeed) async {
    if (newSpeed == _player.speed) {
      return;
    }
    await _player.setSpeed(newSpeed);
  }

  Stream<Duration> get positionStream => _player.positionStream;

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}

class PositionData {
  PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  Duration position;
  Duration bufferedPosition;
  Duration? duration;

  double? get progress {
    if (duration == null || duration == Duration.zero) {
      return null;
    }
    return position.inMilliseconds / duration!.inMilliseconds;
  }

  @override
  String toString() {
    return '{position: $position, bufferedPosition: $bufferedPosition, duration: $duration}';
  }
}

extension CastAudioSource on IndexedAudioSource {
  // Required that the metadata always be set to a cast.
  Cast get cast => tag;
}
