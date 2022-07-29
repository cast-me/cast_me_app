import 'package:cast_me_app/business_logic/models/cast.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class CastAudioPlayer {
  CastAudioPlayer._();

  static final CastAudioPlayer instance = CastAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  final ConcatenatingAudioSource _sourceQueue = ConcatenatingAudioSource(
    useLazyPreparation: true,
    children: [],
  );
  final List<Cast> _castQueue = [];

  // Don't allow direct editing of the queue.
  List<Cast> get queue => _castQueue.toList(growable: false);

  PlayerState get playerState => _player.playerState;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<bool> get playingStream => _player.playingStream;

  /// Delete the queue and play [cast].
  Future<void> play(Cast cast) async {
    if (_castQueue.isNotEmpty && cast == _castQueue.first) {
      return _player.play();
    }
    await _sourceQueue.clear();
    await _sourceQueue.add(AudioSource.uri(cast.audioUri));
    _castQueue.clear();
    _castQueue.add(cast);
    await _player.setAudioSource(_sourceQueue);
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

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
