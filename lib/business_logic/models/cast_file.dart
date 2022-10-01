import 'dart:io';

import 'package:cast_me_app/util/listenable_utils.dart';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:path/path.dart';

class CastFile {
  CastFile({
    required File file,
    this.denoisedFile,
    this.isDenoised = false,
    required this.duration,
  })  : originalFile = file,
        trim = HistoryValueNotifier<Trim>(
          Trim(
            start: Duration.zero,
            end: duration,
          ),
        );

  final File originalFile;

  final File? denoisedFile;

  final Duration duration;

  final bool isDenoised;

  File get file => isDenoised ? denoisedFile! : originalFile;

  String get name => isDenoised
      ? denoisedFile!.uri.pathSegments.last
      : originalFile.uri.pathSegments.last;

  final HistoryValueNotifier<Trim> trim;

  Future<CastFile> trimmed() async {
    if (!trim.canUndo) {
      // Trim was never changed, use file as-is.
      return this;
    }
    final String newName =
        [name.split('.').first, '_trimmed.', name.split('.').last].join();
    final File out = File(
      joinAll(
        List.from(file.uri.pathSegments)
          ..removeLast()
          ..add(newName),
      ),
    );
    final int startMs = trim.value.start.inMilliseconds;
    // ffmpeg expects `to` relative to the specified start.
    final int toMs = trim.value.end.inMilliseconds - startMs;
    final Session session = await FFmpegKit.execute(
      '-i "${file.path}" -ss ${startMs}ms -to ${toMs}ms ${out.path}',
    );
    final ReturnCode? returnCode = await session.getReturnCode();
    assert(
      returnCode == null || returnCode.isValueSuccess(),
      'Trimming cast audio file failed with non-zero exit code '
      '(${returnCode.getValue()}):\n'
      '${returnCode.getValue()}',
    );
    return CastFile(
      file: out,
      duration: duration,
    );
  }

  Future<CastFile> toggleDenoised() async {
    if (denoisedFile != null) {
      // Denoised file is already available, just toggle boolean.
      return CastFile(
        file: originalFile,
        denoisedFile: denoisedFile,
        isDenoised: !isDenoised,
        duration: duration,
      );
    }
    final String newName =
        [name.split('.').first, '_denoised.', name.split('.').last].join();
    final File out = File(
      joinAll(
        List.from(file.uri.pathSegments)
          ..removeLast()
          ..add(newName),
      ),
    );
    final Session session = await FFmpegKit.execute(
      '-i "${file.path}" -af "afftdn=nf=-25" ${out.path}',
    );
    final ReturnCode? returnCode = await session.getReturnCode();
    assert(
      returnCode == null || returnCode.isValueSuccess(),
      'Denoising cast audio file failed with non-zero exit code '
      '(${returnCode.getValue()}):\n'
      '${returnCode.getValue()}',
    );
    return CastFile(
      file: file,
      denoisedFile: out,
      isDenoised: true,
      duration: duration,
    );
  }
}

class Trim {
  Trim({required this.start, required this.end});

  final Duration start;
  final Duration end;
}
