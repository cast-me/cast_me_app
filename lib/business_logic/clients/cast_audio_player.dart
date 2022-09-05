import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/stream_utils.dart';

import 'package:flutter/foundation.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CastAudioPlayer {
  CastAudioPlayer._() {
    bool hasLoggedView = false;
    Cast? lastCast;
    positionDataStream.listen(
      (data) async {
        if (currentCast.value != lastCast) {
          hasLoggedView = false;
          lastCast = currentCast.value;
        }
        // When we first hit 80%, log a view.
        if ((data.progress ?? 0) > .8 && !hasLoggedView) {
          hasLoggedView = true;
          await CastDatabase.instance.setViewed(cast: currentCast.value!);
        }
        if (data.position == data.duration && !_player.hasNext) {
          await _player.pause();
        }
      },
    );
    SharedPreferences.getInstance().then((pref) {
      final double? speed = pref.getDouble(_playbackSpeedKey);
      if (speed == null) {
        return;
      }
      setSpeed(speed);
    });
  }

  static final CastAudioPlayer instance = CastAudioPlayer._();

  static const _playbackSpeedKey = 'playback_speed';

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
    final ConcatenatingAudioSource queue = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: [
        AudioSource.uri(
          cast.audioUri,
          tag: cast,
        ),
      ],
    );
    CastDatabase.instance.getPlayQueue(seedCast: cast).listen((cast) {
      // Use a locally scoped variable so that we don't accidentally add to a
      // later queue.
      queue.add(
        AudioSource.uri(
          cast.audioUri,
          tag: cast,
        ),
      );
    });
    _sourceQueue = queue;
    await _player.setAudioSource(_sourceQueue!);
    await _player.play();
  }

  Future<void> skip() async {
    final Cast cast = currentCast.value!;
    if (!_player.hasNext) {
      // Seek to the end of this cast.
      await _player.seek(await _player.durationFuture);
    } else {
      await _player.seekToNext();
    }
    await CastDatabase.instance.setSkipped(
      cast: cast,
      skippedReason: SkippedReason.nextButton,
    );
  }

  Future<void> previous() async {
    final Cast cast = currentCast.value!;
    if (!_player.hasPrevious || _player.position.inMilliseconds > 2000) {
      // Seek to the beginning of this cast.
      await _player.seek(Duration.zero);
    } else {
      await _player.seekToPrevious();
    }
    await CastDatabase.instance.setSkipped(
      cast: cast,
      skippedReason: SkippedReason.nextButton,
    );
  }

  Future<void> seekToCast(Cast cast) async {
    await _player.seek(
      Duration.zero,
      index: _sourceQueue!.children.indexWhere(
        (uriSource) {
          return (uriSource as UriAudioSource).cast.id == cast.id;
        },
      ),
    );
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

  Future<void> forwardTen() async {
    await seekTo(_player.position + const Duration(seconds: 10));
  }

  Future<void> backwardTen() async {
    await seekTo(_player.position - const Duration(seconds: 10));
  }

  Future<void> setSpeed(double newSpeed) async {
    if (newSpeed == _player.speed) {
      return;
    }
    await SharedPreferences.getInstance().then((pref) {
      pref.setDouble(_playbackSpeedKey, newSpeed);
    });
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
    return '{position: $position, bufferedPosition: $bufferedPosition, '
        'duration: $duration}';
  }
}

extension CastAudioSource on IndexedAudioSource {
  // Required that the metadata always be set to a cast.
  Cast get cast => tag as Cast;
}
