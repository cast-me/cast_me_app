import 'dart:async';

import 'package:share_handler_platform_interface/share_handler_platform_interface.dart';

/// Handles incoming shared audio files for uploading casts.
///
/// ie when the user has another app open and clicks "share" on an audio file
/// and then selects CastMe, this widget handles the incoming file.
class SharedMediaHandler {
  SharedMediaHandler._();

  static Future<void> register(
      void Function(Iterable<String>) handlePaths) async {
    void _handleMedia(SharedMedia media) {
      handlePaths(
        media.attachments!.map((attachment) => attachment!.path),
      );
    }
    final handler = ShareHandlerPlatform.instance;
    final SharedMedia? initialMedia = await handler.getInitialSharedMedia();
    if (initialMedia != null) {
      _handleMedia(initialMedia);
    }
    handler.sharedMediaStream.listen(_handleMedia);
  }
}
