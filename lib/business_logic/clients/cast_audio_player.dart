// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/util/listenable_utils.dart';
import 'package:cast_me_app/util/stream_utils.dart';

class CastAudioPlayer {
  CastAudioPlayer._() {
    bool hasLoggedListen = false;
    Cast? lastCast;
    positionDataStream.listen(
      (data) async {
        if (currentCast.value != lastCast) {
          hasLoggedListen = false;
          lastCast = currentCast.value;
        }
        // When we first hit 80%, log a listen.
        if ((data.progress ?? 0) > .8 && !hasLoggedListen) {
          hasLoggedListen = true;
          await CastDatabase.instance.setListened(cast: currentCast.value!);
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

  static CastAudioPlayer instance = CastAudioPlayer._();

  static const _playbackSpeedKey = 'playback_speed';

  final AudioPlayer _player = AudioPlayer();

  // Add content to this queue.
  ConcatenatingAudioSource? _sourceQueue;

  // Listen for currently playing content from this queue.
  late final ValueListenable<List<IndexedAudioSource>> queue =
      _player.sequenceStream.toListenable().map((lst) => lst ?? []);

  List<Cast> get castQueue => queue.value.map((s) => s.cast).toList();

  late final ValueListenable<Cast?> currentCast =
      _player.sequenceStateStream.map((state) {
    if (state == null) {
      return null;
    }
    return state.sequence[state.currentIndex].cast;
  }).toListenable();

  late final ValueListenable<int?> currentIndex =
      _player.currentIndexStream.toListenable();

  late final ValueListenable<double> currentSpeed =
      _player.speedStream.toListenable().map((value) => value ?? 1);

  PlayerState get playerState => _player.playerState;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<bool> get playingStream => _player.playingStream;

  /// Delete the queue and play [cast].
  Future<void> load(
    Cast cast, {
    required List<Topic> filterTopics,
    List<Cast>? playQueue,
    bool startPlaying = true,
    bool autoPlay = true,
    int startAt = 0,
  }) async {
    if (cast == currentCast.value &&
        const ListEquality<Cast>().equals(playQueue, castQueue)) {
      await _player.seek(Duration.zero, index: startAt);
      return;
    }
    Analytics.instance.logPlay(cast: cast);
    final ConcatenatingAudioSource queue = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: [
        AudioSource.uri(
          cast.audioUri,
          tag: cast,
        ),
      ],
    );
    if (playQueue != null) {
      await queue.addAll(
        playQueue.map((c) => AudioSource.uri(c.audioUri, tag: c)).toList(),
      );
    }
    if (autoPlay) {
      CastDatabase.instance
          .getPlayQueue(
        seedCast: cast,
        filterTopics: filterTopics,
      )
          .listen((cast) {
        if ((playQueue ?? []).contains(cast)) {
          // Don't add duplicate casts.
          // todo(caseycrogers): Filter this out server side.
          return;
        }
        // Use a locally scoped variable so that we don't accidentally add to a
        // later queue.
        queue.add(
          AudioSource.uri(
            cast.audioUri,
            tag: cast,
          ),
        );
      });
    }
    _sourceQueue = queue;
    await _player.setAudioSource(_sourceQueue!, initialIndex: startAt);
    if (startPlaying) {
      await _player.play();
    }
  }

  Future<void> skip() async {
    final Cast cast = currentCast.value!;
    final Duration skippedAt = _player.position;
    if (!_player.hasNext) {
      // Seek to the end of this cast.
      await _player.seek(await _player.durationFuture);
    } else {
      await _player.seekToNext();
    }
    await CastDatabase.instance.setSkipped(
      cast: cast,
      skippedReason: SkippedReason.nextButton,
      skippedAt: skippedAt,
    );
  }

  Future<void> previous() async {
    if (!_player.hasPrevious || _player.position.inMilliseconds > 2000) {
      // Seek to the beginning of this cast.
      await _player.seek(Duration.zero);
    } else {
      await _player.seekToPrevious();
    }
  }

  Future<void> seekToCast(Cast cast) async {
    final Cast? skippedCast = currentCast.value;
    final Duration? skippedAt = skippedCast != null ? _player.position : null;
    Analytics.instance.logSeek(
      targetCast: cast,
      skippedCast: skippedCast,
      skippedAt: skippedAt,
    );
    await _player.seek(
      Duration.zero,
      index: _sourceQueue!.children.indexWhere(
        (uriSource) {
          return (uriSource as UriAudioSource).cast.id == cast.id;
        },
      ),
    );
    if (skippedCast != null) {
      await CastDatabase.instance.setSkipped(
        cast: cast,
        skippedReason: SkippedReason.seekButton,
        skippedAt: skippedAt!,
      );
    }
  }

  Future<void> pause() async {
    Analytics.instance.logPause(
      cast: currentCast.value,
      pausedAt: _player.position,
    );
    await _player.pause();
  }

  Future<void> unPause() async {
    if (currentCast.value == null) {
      return;
    }
    Analytics.instance.logUnpause(
      cast: currentCast.value!,
      unPausedAt: _player.position,
    );
    await _player.play();
  }

  Future<void> seekTo(Duration duration) async {
    Analytics.instance.logSeekTo(
      cast: currentCast.value!,
      seekedAt: _player.position,
      seekedTo: duration,
    );
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
    Analytics.instance.logSetSpeed(
      cast: currentCast.value,
      fromSpeed: _player.speed,
      toSpeed: newSpeed,
    );
    await SharedPreferences.getInstance().then((pref) {
      pref.setDouble(_playbackSpeedKey, newSpeed);
    });
    await _player.setSpeed(newSpeed);
  }

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @visibleForTesting
  static void reset() {
    instance._player.dispose();
    instance = CastAudioPlayer._();
  }
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
