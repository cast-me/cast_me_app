// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/audio_recorder.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/topic.dart';
import 'package:cast_me_app/widgets/listen_page/topics_view.dart';

class PostBloc {
  PostBloc._();

  static PostBloc instance = PostBloc._();

  ValueListenable<Future<CastFile>?> get castFile => _castFile;

  final ValueNotifier<Cast?> replyCast = ValueNotifier(null);

  final ValueNotifier<List<Topic>> topics = ValueNotifier([]);

  final ValueNotifier<Future<CastFile>?> _castFile = ValueNotifier(null);

  final TopicSelectorController topicSelectorController =
      TopicSelectorController();

  // Used as a hack to force the title text field to rebuild.
  Key titleFieldKey = UniqueKey();
  final ValueNotifier<String> titleText = ValueNotifier('');

  final TextEditingController externalLinkTextController =
      TextEditingController();

  Future<void> _onTrimChanged() async {
    final Trim trim = (await _castFile.value!).trim.value;
    return ClipAudioPlayer.instance.setClip(
      start: trim.start,
      end: trim.end,
    );
  }

  Future<void> clearFiles() async {
    if (castFile.value == null) {
      return;
    }
    (await _castFile.value!).trim.removeListener(_onTrimChanged);
    _castFile.value = null;
    await ClipAudioPlayer.instance.setFile(null);
  }

  void onFileSelected(Future<String> asyncPath) {
    // Wrap in a sub-function to ensure that thrown errors are captured in the
    // cast file future.
    _castFile.value = () async {
      final String path = await asyncPath;
      final Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final String name = Uri(path: path).pathSegments.last;
      await File(path).readAsBytes();
      final File file = File(path).copySync(
        join(documentsDirectory.path, name),
      );
      final Duration duration = (await ClipAudioPlayer.instance.setFile(file))!;
      if (duration < const Duration(seconds: 5)) {
        throw ArgumentError('Casts must be at least 5 seconds long!');
      }
      final CastFile castFile = await CastFile.initiallyDenoised(
        file: file,
        originalDuration: duration,
      );
      castFile.trim.addListener(_onTrimChanged);
      return castFile;
    }();
  }

  Future<void> onFileUpdated(CastFile castFile) async {
    await ClipAudioPlayer.instance.setFile(castFile.file);
    // We're okay doing this synchronously instead of with a completer because
    // displaying a spinner on every update would be annoying.
    _castFile.value = Future.value(castFile);
    (await _castFile.value!).trim.addListener(_onTrimChanged);
    // Force an immediate trim check in case the cast file has a trim.
    await _onTrimChanged();
  }

  // TODO: this is sloppy, we should just replace instance with a new instance.
  Future<String> submitFile({
    required String title,
    required String url,
    required CastFile castFile,
  }) async {
    final String castId = await CastDatabase.instance.createCast(
      title: title,
      castFile: await castFile.applyTrim(),
      replyTo: replyCast.value,
      url: url,
      topics: replyCast.value == null ? topics.value : [],
    );
    return castId;
  }

  Future<void> startRecording() async {
    final DateFormat formatter = DateFormat('yyyy_MM_dd_ssSSS');
    final DateTime now = DateTime.now();
    final String name = 'recording_${formatter.format(now)}';
    return AudioRecorder.instance.startRecording(name: name);
  }

  void stopRecording() {
    PostBloc.instance.onFileSelected(AudioRecorder.instance.stopRecording());
  }

  void reset() {
    clearFiles();
    replyCast.value = null;
    topics.value = [];
    externalLinkTextController.text = '';
    titleText.value = '';
    // Gross hack to force the title field to rebuild from scratch.
    titleFieldKey = UniqueKey();
  }

  @visibleForTesting
  void overrideCastFile(CastFile castFile) {
    _castFile.value = Future.value(castFile);
  }
}
