import 'dart:io';

import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class PostBloc {
  PostBloc._();

  static final instance = PostBloc._();

  ValueListenable<List<CastFile>> get castFiles => _castFiles;

  final ValueNotifier<Cast?> replyCast = ValueNotifier(null);

  final ValueNotifier<List<CastFile>> _castFiles = ValueNotifier(List.empty());

  void popFirstFile() {
    _castFiles.value = _castFiles.value.sublist(1);
  }

  Future<void> onFilesSelected(Iterable<String> paths) async {
    _castFiles.value = await Future.wait(
      paths.map((path) async {
        final File file = File(path);
        // TODO(caseycrogers): we read bytes into memory because the OS may
        // delete the file before we upload it (it's stored in a temp dir).
        // Consider copying the file to a safe directory instead of reading
        // bytes.
        final Uint8List bytes = await file.readAsBytes();
        return CastFile(
          platformFile: PlatformFile(
            name: file.uri.pathSegments.last,
            size: bytes.lengthInBytes,
            bytes: bytes,
          ),
          durationMs: await getFileDuration(path),
        );
      }),
    );
    _castFiles.value = [
      ...castFiles.value,
    ];
  }
}

class CastFile {
  CastFile({
    required this.platformFile,
    required this.durationMs,
  });

  final PlatformFile platformFile;
  final int durationMs;
}
