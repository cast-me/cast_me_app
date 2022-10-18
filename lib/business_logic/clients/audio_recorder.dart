import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorder {
  AudioRecorder._();

  static final AudioRecorder instance = AudioRecorder._();

  final _record = Record();

  final ValueNotifier<bool> _isRecording = ValueNotifier(false);

  final Stopwatch durationRecording = Stopwatch();

  ValueListenable<bool> get isRecording => _isRecording;

  late final Stream<Amplitude> amplitudes = _record
      .onAmplitudeChanged(const Duration(milliseconds: 100))
      .asBroadcastStream();

  Future<void> startRecording({
    required String name,
  }) async {
    assert(!_isRecording.value);
    await CastAudioPlayer.instance.pause();
    await ClipAudioPlayer.instance.pause();
    if (await _record.hasPermission()) {
      await _record.start(
        path: join((await getTemporaryDirectory()).path, '$name.m4a'),
      );
      durationRecording.reset();
      durationRecording.start();
      _isRecording.value = true;
      return;
    }
    throw Exception('You have to give CastMe permission to use your mic, check '
        'your settings.');
  }

  /// Finishes recording and returns the path to the recorded file.
  Future<String> stopRecording() async {
    assert(_isRecording.value);
    final String path = (await _record.stop())!;
    durationRecording.stop();
    _isRecording.value = false;
    return path;
  }
}
