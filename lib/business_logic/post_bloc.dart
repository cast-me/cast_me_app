// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/clients/clip_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';

class PostBloc {
  PostBloc._();

  static final instance = PostBloc._();

  ValueListenable<CastFile?> get castFile => _castFile;

  final ValueNotifier<Cast?> replyCast = ValueNotifier(null);

  final ValueNotifier<List<Topic>> topics = ValueNotifier([]);

  final ValueNotifier<CastFile?> _castFile = ValueNotifier(null);

  Future<void> _onTrimChanged() async {
    final Trim trim = _castFile.value!.trim.value;
    return ClipAudioPlayer.instance.setClip(
      start: trim.start,
      end: trim.end,
    );
  }

  void clearFiles() {
    _castFile.value!.trim.removeListener(_onTrimChanged);
    _castFile.value = null;
    ClipAudioPlayer.instance.setFile(null);
  }

  Future<void> onFileSelected(String path) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String name = Uri(path: path).pathSegments.last;
    await File(path).readAsBytes();
    final File file = File(path).copySync(
      join(documentsDirectory.path, name),
    );
    final Duration duration = (await ClipAudioPlayer.instance.setFile(file))!;
    if (duration < const Duration(seconds: 10)) {
      throw ArgumentError('Casts must be at least 10 seconds long!');
    }
    final CastFile castFile = await CastFile.initiallyDenoised(
      file: file,
      originalDuration: duration,
    );
    _castFile.value = castFile;
    _castFile.value!.trim.addListener(_onTrimChanged);
  }

  Future<void> onFileUpdated(CastFile castFile) async {
    final Duration duration =
        (await ClipAudioPlayer.instance.setFile(castFile.file))!;
    if (duration < const Duration(seconds: 10)) {
      throw ArgumentError('Casts must be at least 10 seconds long!');
    }
    _castFile.value = castFile;
    _castFile.value!.trim.addListener(_onTrimChanged);
    // Force an immediate trim check in case the cast file has a trim.
    await _onTrimChanged();
  }

  // TODO: this is sloppy, we should just replace instance with a new instance.
  Future<void> submitFile({
    required String title,
    required String url,
    required CastFile castFile,
  }) async {
    await CastDatabase.instance.createCast(
      title: title,
      castFile: await castFile.applyTrim(),
      replyTo: replyCast.value,
      url: url,
      topics: replyCast.value == null ? topics.value : [],
    );
    clearFiles();
    replyCast.value = null;
    topics.value = [];
  }
}
