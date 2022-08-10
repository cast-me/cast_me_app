import 'dart:io';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/string_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  // TODO(caseycrogers): paginate this.
  Stream<Cast> getCasts({Profile? filterProfile}) async* {
    PostgrestFilterBuilder queryBuilder = castsReadQuery.select();
    if (filterProfile != null) {
      // Get only casts authored by the given profiles.
      queryBuilder = queryBuilder.eq(authorIdCol, filterProfile.id);
    }
    final List<Cast>? casts = await queryBuilder.withConverter((dynamic data) {
      return (data as Iterable<dynamic>).map(_rowToCast).toList();
    });
    for (final Cast cast in casts ?? <Cast>[]) {
      yield cast;
    }
  }

  Future<void> createCast({
    required String title,
    required File file,
  }) async {
    final int durationMs = await _getFileDuration(file.path);
    final String fileExt = file.path.split('.').last;
    // Hash the file name so we don't get naming conflicts.
    final String fileName =
        '${await sha1.bind(file.openRead()).first}.$fileExt';

    await castAudioFileBucket.upload(
      fileName,
      file,
      fileOptions: const FileOptions(upsert: true),
    );
    final String audioFileUrl = castAudioFileBucket.getPublicUrl(fileName);
    final Cast cast = Cast(
      authorId: supabase.auth.currentUser!.id,
      title: title,
      // TODO(caseycrogers): consider moving this to a server function.
      durationMs: durationMs,
      audioUrl: audioFileUrl,
    );
    await castsWriteQuery.insert(_castToRow(cast));
  }

  Future<void> deleteCast({
    required Cast cast,
  }) async {
    print(await castsWriteQuery.select().eq(castIdCol, cast.id).maybeSingle());
    final List<dynamic> rowResult =
        await castsWriteQuery.delete().eq(castIdCol, cast.id) as List<dynamic>;
    assert(
      rowResult.isNotEmpty,
      'Could not find a cast with id \'${cast.id}\'',
    );
    final List<FileObject> storageResult =
        await castAudioFileBucket.remove([cast.audioPath]);
    assert(
      storageResult.isNotEmpty,
      'Could not find a cast audio file at path \'${cast.audioPath}\'.',
    );
  }
}

Cast _rowToCast(dynamic row) {
  final Map<String, dynamic> rowMap = row as Map<String, dynamic>;
  return Cast.create()
    ..mergeFromProto3Json(
      // TODO(caseycrogers): consider figuring out how to use timestamp.proto.
      <String, dynamic>{
        'created_at_string': rowMap['created_at'].toString(),
        ...rowMap,
      }..remove('created_at'),
    );
}

Map<String, dynamic> _castToRow(Cast cast) {
  return (cast.toProto3Json() as Map<String, dynamic>).toSnakeCase();
}

Future<int> _getFileDuration(String mediaPath) async {
  final mediaInfoSession = await FFprobeKit.getMediaInformation(mediaPath);
  final mediaInfo = mediaInfoSession.getMediaInformation()!;

  // the given duration is in fractional seconds, convert to ms
  final int durationMs =
      (double.parse(mediaInfo.getDuration()!) * 1000).round();
  return durationMs;
}
