import 'dart:io';

import 'package:cast_me_app/util/listenable_utils.dart';

import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:ffmpeg_kit_flutter_audio/session.dart';

import 'package:path/path.dart' as path;

class CastFile {
  CastFile({
    required File file,
    this.denoisedFile,
    this.isDenoised = false,
    required this.originalDuration,
  })  : originalFile = file,
        trim = HistoryValueNotifier<Trim>(
          Trim(
            start: Duration.zero,
            end: originalDuration,
          ),
        );

  final File originalFile;

  final File? denoisedFile;

  final Duration originalDuration;

  final bool isDenoised;

  File get file => isDenoised ? denoisedFile! : originalFile;

  String get name => isDenoised
      ? denoisedFile!.uri.pathSegments.last
      : originalFile.uri.pathSegments.last;

  Duration get duration => trim.value.end - trim.value.start;

  final HistoryValueNotifier<Trim> trim;

  Future<CastFile> applyTrim() async {
    if (!trim.canUndo) {
      // Trim was never changed, use file as-is.
      return this;
    }
    final File out = File('${path.withoutExtension(file.path)}_trimmed.mp3');
    final int startMs = trim.value.start.inMilliseconds;
    // ffmpeg expects `to` relative to the specified start.
    final int toMs = trim.value.end.inMilliseconds - startMs;
    final Session session = await FFmpegKit.execute(
      '-i "${file.path}" -ss ${startMs}ms -to ${toMs}ms  -c:a libmp3lame'
      ' "${out.path}"',
    );
    final ReturnCode? returnCode = await session.getReturnCode();
    assert(
      returnCode == null || returnCode.isValueSuccess(),
      'Trimming cast audio file failed with non-zero exit code '
      '(${returnCode.getValue()}).',
    );
    return CastFile(
      file: out,
      originalDuration: duration,
    );
  }

  Future<CastFile> toggleDenoised() async {
    if (denoisedFile != null) {
      // Denoised file is already available, just toggle boolean.
      return CastFile(
        file: originalFile,
        denoisedFile: denoisedFile,
        isDenoised: !isDenoised,
        originalDuration: originalDuration,
      );
    }
    final File out = File('${path.withoutExtension(file.path)}_denoised.mp3');
    if (!out.existsSync()) {
      // Use mp3 because iOS barfs on m4a's generated by ffmpeg.
      final Session session = await FFmpegKit.execute(
        '-i "${file.path}" -af afftdn=nf=-25 -c:a libmp3lame "${out.path}"',
      );
      final ReturnCode? returnCode = await session.getReturnCode();
      if (returnCode != null && !returnCode.isValueSuccess()) {
        throw Exception((await session.getAllLogs()).last.getMessage());
      }
    }
    return CastFile(
      file: file,
      denoisedFile: out,
      isDenoised: true,
      originalDuration: originalDuration,
    );
  }
}

class Trim {
  Trim({required this.start, required this.end});

  final Duration start;
  final Duration end;
}
