import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/business_logic/post_bloc.dart';
import 'package:cast_me_app/util/string_utils.dart';

import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/media_information.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  // TODO(caseycrogers): paginate this.
  Stream<Cast> getCasts({
    Profile? filterProfile,
    Profile? filterOutProfile,
    bool skipViewed = false,
    bool oldestFirst = false,
    String? searchTerm,
  }) async* {
    PostgrestFilterBuilder queryBuilder = castsReadQuery.select();
    if (filterProfile != null) {
      // Get only casts authored by the given profiles.
      queryBuilder = queryBuilder.eq(authorIdCol, filterProfile.id);
    }
    if (filterOutProfile != null) {
      queryBuilder = queryBuilder.neq(authorIdCol, filterOutProfile.id);
    }
    if (skipViewed) {
      queryBuilder = queryBuilder.eq(hasViewedCol, false);
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder = queryBuilder.ilike(titleCol, '%$searchTerm%');
    }
    final List<Cast>? casts = await queryBuilder
        .order(hasViewedCol, ascending: true)
        .order(createdAtCol, ascending: oldestFirst)
        .withConverter((dynamic data) {
      return (data as Iterable<dynamic>).map(_rowToCast).toList();
    });
    for (final Cast cast in casts ?? <Cast>[]) {
      yield cast;
    }
  }

  Stream<Cast> getPlayQueue({required Cast seedCast}) {
    return getCasts(
      skipViewed: true,
      filterOutProfile: AuthManager.instance.profile,
      oldestFirst: true,
    ).where((cast) => cast.id != seedCast.id);
  }

  Future<void> createCast({
    required String title,
    required CastFile castFile,
  }) async {
    // TODO(caseycrogers): consider moving this to a server function.
    final String fileExt = castFile.platformFile.name.split('.').last;
    // Hash the file name so we don't get naming conflicts. Since we're using a
    // hash, redundant uploads won't increase storage usage. We're prefixing
    // with the username so that when a user deletes a cast we can safely delete
    // the storage object-we're preventing another user from uploading the same
    // file under the exact same name.
    final String fileName = '${AuthManager.instance.profile.username}'
        '_${sha1.convert(castFile.platformFile.bytes!)}.$fileExt';

    await castAudioFileBucket.uploadBinary(
      fileName,
      castFile.platformFile.bytes!,
      fileOptions: const FileOptions(upsert: true),
    );
    final String audioFileUrl = castAudioFileBucket.getPublicUrl(fileName);
    final Cast cast = Cast(
      authorId: supabase.auth.currentUser!.id,
      title: title,
      durationMs: castFile.durationMs,
      audioUrl: audioFileUrl,
    );
    await castsWriteQuery.insert(_castToRow(cast));
  }

  Future<void> deleteCast({
    required Cast cast,
  }) async {
    await listensQuery.delete().eq('cast_id', cast.id) as List<dynamic>;
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

  Future<void> setListened({required Cast cast}) async {
    await listensQuery.insert({
      'cast_id': cast.id,
      'user_id': supabase.auth.currentUser!.id,
    });
  }

  Future<void> setSkipped({
    required Cast cast,
    required SkippedReason skippedReason,
  }) async {
    await listensQuery.insert({
      'cast_id': cast.id,
      'user_id': supabase.auth.currentUser!.id,
      'skipped_reason': skippedReason.toString().split('.').last,
    });
  }
}

enum SkippedReason {
  nextButton,
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

Future<int> getFileDuration(String mediaPath) async {
  final MediaInformationSession mediaInfoSession =
      await FFprobeKit.getMediaInformation(mediaPath);
  final MediaInformation? mediaInfo = mediaInfoSession.getMediaInformation();

  // the given duration is in fractional seconds, convert to ms
  final int durationMs =
      (double.parse(mediaInfo!.getDuration()!) * 1000).round();
  return durationMs;
}
