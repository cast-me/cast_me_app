import 'dart:io';

import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/clients/file_audio_player.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/models/cast_file.dart';

import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PostBloc {
  PostBloc._();

  static final instance = PostBloc._();

  ValueListenable<CastFile?> get castFile => _castFile;

  final ValueNotifier<Cast?> replyCast = ValueNotifier(null);

  final ValueNotifier<bool> denoise = ValueNotifier(false);

  final ValueNotifier<CastFile?> _castFile = ValueNotifier(null);

  Future<void> _onTrimChanged() async {
    final Trim trim = _castFile.value!.trim.value;
    return FileAudioPlayer.instance.setClip(
      start: trim.start,
      end: trim.end,
    );
  }

  void clearFiles() {
    _castFile.value!.trim.removeListener(_onTrimChanged);
    _castFile.value = null;
    denoise.value = false;
    FileAudioPlayer.instance.setFile(null);
  }

  Future<void> onFileSelected(String path) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String name = Uri(path: path).pathSegments.last;
    await File(path).readAsBytes();
    final File file = File(path).copySync(
      join(documentsDirectory.path, name),
    );
    final Duration duration = (await FileAudioPlayer.instance.setFile(file))!;
    if (duration < const Duration(seconds: 10)) {
    throw ArgumentError('Casts must be at least 10 seconds long!');
    }
    _castFile.value = CastFile(
    file: file,
    duration: duration,
    );
    denoise.value = false;
    _castFile.value!.trim.addListener(_onTrimChanged);
  }

  Future<void> onFileUpdated(CastFile castFile) async {
    final Duration duration =
        (await FileAudioPlayer.instance.setFile(castFile.file))!;
    if (duration < const Duration(seconds: 10)) {
      throw ArgumentError('Casts must be at least 10 seconds long!');
    }
    _castFile.value = castFile;
    _castFile.value!.trim.addListener(_onTrimChanged);
    // Force an immediate trim check in case the cast file has a trim.
    await _onTrimChanged();
  }

  Future<void> submitFile({
    required String title,
    required CastFile castFile,
  }) async {
    await CastDatabase.instance.createCast(
      title: title,
      castFile: await castFile.trimmed(),
      replyTo: PostBloc.instance.replyCast.value,
    );
    PostBloc.instance.clearFiles();
    PostBloc.instance.replyCast.value = null;
  }
}
