import 'package:audio_service/audio_service.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundAudioHandler extends BaseAudioHandler {
  BackgroundAudioHandler._() {
    _player.playerStateStream.listen((state) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (state.playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
          processingState: _convertStateType(state.processingState),
        ),
      );
    });
  }

  static final instance = BackgroundAudioHandler._();

  static final CastAudioPlayer _player = CastAudioPlayer.instance;

  @override
  Future<void> play() {
    return _player.unPause();
  }

  @override
  Future<void> pause() {
    return _player.pause();
  }

  @override
  Future<void> skipToNext() {
    return _player.skipToNext();
  }

  @override
  Future<void> skipToPrevious() {
    return _player.skipBackward();
  }
}

AudioProcessingState _convertStateType(ProcessingState state) {
  switch (state) {
    case ProcessingState.idle:
      return AudioProcessingState.idle;
    case ProcessingState.loading:
      return AudioProcessingState.loading;
    case ProcessingState.buffering:
      return AudioProcessingState.buffering;
    case ProcessingState.ready:
      return AudioProcessingState.ready;
    case ProcessingState.completed:
      return AudioProcessingState.completed;
  }
}