import 'package:flutter/foundation.dart';

import 'package:record/record.dart';

class AudioRecorder {
  AudioRecorder._();

  static final AudioRecorder instance = AudioRecorder._();

  final _record = Record();

  final ValueNotifier<bool> _isRecording = ValueNotifier(false);

  ValueListenable<bool> get isRecording => _isRecording;

  Future<void> startRecording() async {
    assert(!_isRecording.value);
    if (await _record.hasPermission()) {
      // Start recording
      await _record.start(
        path: 'aFullPath/myFile.m4a',
      );
    }
  }

  Future<String?> stopRecording() async {
    assert(_isRecording.value);
    return _record.stop();
  }
}
